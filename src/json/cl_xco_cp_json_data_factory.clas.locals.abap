CLASS lcl_json_data DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_json_data.

    METHODS constructor
      IMPORTING
        iv_json TYPE string.

  PRIVATE SECTION.
    DATA mv_json TYPE string.
ENDCLASS.

CLASS lcl_json_data_builder DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_json_data_builder.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_context,
        kind           TYPE c LENGTH 1,
        first          TYPE abap_bool,
        awaiting_value TYPE abap_bool,
      END OF ty_context,
      ty_contexts TYPE STANDARD TABLE OF ty_context WITH DEFAULT KEY.

    DATA mv_json TYPE string.
    DATA mt_contexts TYPE ty_contexts.

    METHODS prepare_value.
ENDCLASS.

CLASS lcl_json_data IMPLEMENTATION.
  METHOD constructor.
    mv_json = iv_json.
  ENDMETHOD.

  METHOD if_xco_cp_json_data~to_string.
    rv_json = mv_json.
  ENDMETHOD.

  METHOD if_xco_cp_json_data~traverse.
    io_visitor->on_start( ).
    io_visitor->on_end( ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_json_data_builder IMPLEMENTATION.
  METHOD prepare_value.
    READ TABLE mt_contexts ASSIGNING FIELD-SYMBOL(<ls_context>) INDEX lines( mt_contexts ).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF <ls_context>-kind = 'A'.
      IF <ls_context>-first = abap_false.
        mv_json = mv_json && ','.
      ENDIF.
      <ls_context>-first = abap_false.
    ELSE.
      <ls_context>-awaiting_value = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~begin_object.
    prepare_value( ).
    mv_json = mv_json && '{'.
    APPEND VALUE #( kind = 'O' first = abap_true ) TO mt_contexts.
    ro_builder = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~end_object.
    mv_json = mv_json && '}'.
    DELETE mt_contexts INDEX lines( mt_contexts ).
    ro_builder = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~begin_array.
    prepare_value( ).
    mv_json = mv_json && '['.
    APPEND VALUE #( kind = 'A' first = abap_true ) TO mt_contexts.
    ro_builder = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~end_array.
    mv_json = mv_json && ']'.
    DELETE mt_contexts INDEX lines( mt_contexts ).
    ro_builder = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~add_member.
    READ TABLE mt_contexts ASSIGNING FIELD-SYMBOL(<ls_context>) INDEX lines( mt_contexts ).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    IF <ls_context>-first = abap_false.
      mv_json = mv_json && ','.
    ENDIF.

    DATA(lv_name) = /ui2/cl_json=>serialize( iv_name ).
    mv_json = mv_json && lv_name && ':'.
    <ls_context>-first = abap_false.
    <ls_context>-awaiting_value = abap_true.
    ro_builder = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~add_string.
    prepare_value( ).
    mv_json = mv_json && /ui2/cl_json=>serialize( iv_value ).
    ro_builder = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~add_boolean.
    prepare_value( ).
    IF iv_value = abap_true.
      mv_json = mv_json && 'true'.
    ELSE.
      mv_json = mv_json && 'false'.
    ENDIF.
    ro_builder = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~add_number.
    prepare_value( ).
    mv_json = mv_json && /ui2/cl_json=>serialize( iv_value ).
    ro_builder = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~get_data.
    ro_data = NEW lcl_json_data( mv_json ).
  ENDMETHOD.
ENDCLASS.
