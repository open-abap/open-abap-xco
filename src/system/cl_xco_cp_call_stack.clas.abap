CLASS cl_xco_cp_call_stack DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_call_stack.

    TYPES:
      BEGIN OF ty_frame,
        object     TYPE string,
        is_system  TYPE abap_bool,
        event      TYPE string,
        event_type TYPE string,
      END OF ty_frame,
      ty_frames TYPE STANDARD TABLE OF ty_frame WITH EMPTY KEY.

    DATA mt_frames TYPE ty_frames READ-ONLY.

    "! The ABAP frames of the stack of a JavaScript Error, innermost first
    "! @parameter iv_stack | the "stack" of the Error, as V8 writes it
    "! @parameter iv_skip | number of innermost ABAP frames to leave out
    CLASS-METHODS from_javascript
      IMPORTING
        iv_stack             TYPE string
        iv_skip              TYPE i DEFAULT 0
      RETURNING
        VALUE(ro_call_stack) TYPE REF TO cl_xco_cp_call_stack.

    METHODS constructor
      IMPORTING
        it_frames TYPE ty_frames.

  PRIVATE SECTION.
    CLASS-METHODS parse_frame
      IMPORTING
        iv_line         TYPE string
      RETURNING
        VALUE(rs_frame) TYPE ty_frame.

    CLASS-METHODS abap_name
      IMPORTING
        iv_javascript_name TYPE string
      RETURNING
        VALUE(rv_name)     TYPE string.

    CLASS-METHODS is_function_module
      IMPORTING
        iv_name       TYPE string
      RETURNING
        VALUE(rv_yes) TYPE abap_bool.
ENDCLASS.

CLASS cl_xco_cp_call_stack IMPLEMENTATION.
  METHOD constructor.
    mt_frames = it_frames.
  ENDMETHOD.

  METHOD from_javascript.
    DATA lt_frames TYPE ty_frames.

    SPLIT iv_stack AT |\n| INTO TABLE DATA(lt_lines).
    LOOP AT lt_lines INTO DATA(lv_line).
      DATA(ls_frame) = parse_frame( lv_line ).
      IF ls_frame IS NOT INITIAL.
        APPEND ls_frame TO lt_frames.
      ENDIF.
    ENDLOOP.

    IF iv_skip > 0.
      DELETE lt_frames FROM 1 TO iv_skip.
    ENDIF.

    ro_call_stack = NEW #( lt_frames ).
  ENDMETHOD.

  METHOD parse_frame.
    " V8 writes a frame as "    at async zcl_order_service.cancel (file:///out/zcl_order_service.clas.mjs:12:5)",
    " and the code of a program outside of its routines as "    at file:///out/zreport.prog.mjs:3:1"
    DATA lv_async TYPE string.
    DATA lv_new TYPE string.
    DATA lv_function TYPE string.
    DATA lv_location TYPE string.
    DATA lv_file TYPE string.

    FIND REGEX `^\s*at (async )?(new )?(\S+) \((.*)\)$` IN iv_line
      SUBMATCHES lv_async lv_new lv_function lv_location.
    IF sy-subrc <> 0.
      FIND REGEX `^\s*at (async )?(.*)$` IN iv_line SUBMATCHES lv_async lv_location.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
    ENDIF.

    " "new <class>" creates the JavaScript object, the ABAP constructor is a method of its own
    IF lv_new IS NOT INITIAL.
      RETURN.
    ENDIF.

    " the name of the file, without the path and without ":line:column"
    FIND REGEX `([^/\\]+):\d+:\d+$` IN lv_location SUBMATCHES lv_file.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " transpiled ABAP is in "<object>.<type>[.<include>].mjs", or "<object>.<type>[.<include>].abap" with
    " source maps; the test runner and the JavaScript runtime are not ABAP and have no frames here
    SPLIT lv_file AT '.' INTO TABLE DATA(lt_parts).
    IF lines( lt_parts ) < 3.
      RETURN.
    ENDIF.
    DATA(lv_name) = to_upper( translate( val  = lt_parts[ 1 ]
                                         from = '#'
                                         to   = '/' ) ).
    DATA(lv_type) = to_upper( lt_parts[ 2 ] ).

    " methods are written "<class>.<method>", private methods "#<method>", forms and function modules
    " by their name, and a function without a name has none
    DATA(lv_in_class) = xsdbool( lv_function CA '.#' ).
    SPLIT lv_function AT '.' INTO TABLE DATA(lt_names).
    DATA(lv_event) = VALUE string( lt_names[ lines( lt_names ) ] OPTIONAL ).
    SHIFT lv_event LEFT DELETING LEADING '#'.
    CASE lv_event.
      WHEN `<anonymous>`.
        CLEAR lv_event.
      WHEN `constructor_`.
        " a text literal, the runtime caches character literals in a plain object, where "constructor" is taken
        lv_event = `constructor`.
    ENDCASE.
    lv_event = abap_name( lv_event ).

    rs_frame-object = lv_name.
    rs_frame-is_system = xsdbool( NOT ( lv_name CP 'Z*' OR lv_name CP 'Y*' OR lv_name CP '/*' ) ).
    rs_frame-event = lv_event.

    CASE lv_type.
      WHEN 'CLAS' OR 'INTF'.
        IF lv_event IS INITIAL.
          CLEAR rs_frame.
          RETURN.
        ENDIF.
        rs_frame-event_type = 'method'.
      WHEN 'PROG'.
        IF lv_event IS INITIAL.
          rs_frame-event = 'start-of-selection'.
          rs_frame-event_type = 'event'.
        ELSEIF lv_in_class = abap_true.
          rs_frame-event_type = 'method'.
        ELSE.
          rs_frame-event_type = 'form'.
        ENDIF.
      WHEN 'FUGR'.
        IF lv_event IS INITIAL.
          CLEAR rs_frame.
          RETURN.
        ELSEIF lv_in_class = abap_true.
          rs_frame-event_type = 'method'.
        ELSEIF is_function_module( lv_event ) = abap_true.
          rs_frame-event_type = 'function'.
        ELSE.
          rs_frame-event_type = 'form'.
        ENDIF.
        " the main program of the function group
        FIND REGEX `^(/[^/]+/)(.+)$` IN lv_name SUBMATCHES DATA(lv_namespace) DATA(lv_group).
        IF sy-subrc = 0.
          rs_frame-object = |{ lv_namespace }SAPL{ lv_group }|.
        ELSE.
          rs_frame-object = |SAPL{ lv_name }|.
        ENDIF.
      WHEN OTHERS.
        CLEAR rs_frame.
    ENDCASE.
  ENDMETHOD.

  METHOD abap_name.
    " the "/" of a namespace and the "~" of an interface component are both written "$":
    " "$ns$if_order$cancel" is "/ns/if_order~cancel"
    rv_name = iv_javascript_name.
    REPLACE REGEX `^\$([^$]+)\$` IN rv_name WITH `/$1/`.
    REPLACE REGEX `\$\$([^$]+)\$` IN rv_name WITH `~/$1/`.
    REPLACE `$` IN rv_name WITH `~`.
  ENDMETHOD.

  METHOD is_function_module.
    DATA lv_funcname TYPE c LENGTH 30.

    lv_funcname = to_upper( iv_name ).
    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING
        funcname           = lv_funcname
      EXCEPTIONS
        function_not_exist = 1
        OTHERS             = 2.
    rv_yes = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD if_xco_cp_call_stack~as_text.
    DATA lt_lines TYPE string_table.

    DATA(lo_format) = io_format->get_implementation( ).
    LOOP AT mt_frames INTO DATA(ls_frame).
      DATA(lv_line) = lo_format->format_frame( ls_frame ).
      APPEND lv_line TO lt_lines.
    ENDLOOP.

    ro_text = NEW cl_xco_strings( lt_lines ).
  ENDMETHOD.
ENDCLASS.
