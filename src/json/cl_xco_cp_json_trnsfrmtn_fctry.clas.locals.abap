CLASS lcl_transformation DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_json_transformation.

    TYPES ty_kind TYPE c LENGTH 1.

    CONSTANTS:
      BEGIN OF gc_kind,
        camel_case_to_underscore  TYPE ty_kind VALUE 'C',
        pascal_case_to_underscore TYPE ty_kind VALUE 'P',
        underscore_to_camel_case  TYPE ty_kind VALUE 'c',
        underscore_to_pascal_case TYPE ty_kind VALUE 'p',
        boolean_to_abap_bool      TYPE ty_kind VALUE 'B',
        name_replacement          TYPE ty_kind VALUE 'R',
      END OF gc_kind.

    METHODS constructor
      IMPORTING
        iv_kind         TYPE ty_kind
        it_name_mapping TYPE sxco_t_json_name_mapping OPTIONAL.

    METHODS transform_name
      IMPORTING
        iv_name        TYPE string
      RETURNING
        VALUE(rv_name) TYPE string.

    METHODS converts_booleans
      RETURNING
        VALUE(rv_converts) TYPE abap_bool.

  PRIVATE SECTION.
    DATA mv_kind         TYPE ty_kind.
    DATA mt_name_mapping TYPE sxco_t_json_name_mapping.

    METHODS to_underscore
      IMPORTING
        iv_name        TYPE string
      RETURNING
        VALUE(rv_name) TYPE string.

    METHODS from_underscore
      IMPORTING
        iv_name        TYPE string
        iv_pascal_case TYPE abap_bool
      RETURNING
        VALUE(rv_name) TYPE string.

    METHODS replace_name
      IMPORTING
        iv_name        TYPE string
      RETURNING
        VALUE(rv_name) TYPE string.
ENDCLASS.

" the start and the end of a traversal have no counterpart in a tree builder
CLASS lcl_forwarding_visitor DEFINITION ABSTRACT.
  PUBLIC SECTION.
    INTERFACES if_xco_json_tree_visitor
      ABSTRACT METHODS enter_object leave_object enter_array leave_array
                       visit_member visit_string visit_number visit_boolean visit_null.
ENDCLASS.

CLASS lcl_forwarding_visitor IMPLEMENTATION.
  METHOD if_xco_json_tree_visitor~on_start.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~on_end.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_visitor DEFINITION FINAL INHERITING FROM lcl_forwarding_visitor.
  PUBLIC SECTION.
    METHODS if_xco_json_tree_visitor~enter_object REDEFINITION.
    METHODS if_xco_json_tree_visitor~leave_object REDEFINITION.
    METHODS if_xco_json_tree_visitor~enter_array REDEFINITION.
    METHODS if_xco_json_tree_visitor~leave_array REDEFINITION.
    METHODS if_xco_json_tree_visitor~visit_member REDEFINITION.
    METHODS if_xco_json_tree_visitor~visit_string REDEFINITION.
    METHODS if_xco_json_tree_visitor~visit_number REDEFINITION.
    METHODS if_xco_json_tree_visitor~visit_boolean REDEFINITION.
    METHODS if_xco_json_tree_visitor~visit_null REDEFINITION.

    METHODS constructor
      IMPORTING
        io_tree_builder   TYPE REF TO if_xco_json_tree_builder
        io_transformation TYPE REF TO lcl_transformation.

  PRIVATE SECTION.
    DATA mo_tree_builder   TYPE REF TO if_xco_json_tree_builder.
    DATA mo_transformation TYPE REF TO lcl_transformation.
ENDCLASS.

CLASS lcl_transformation IMPLEMENTATION.
  METHOD constructor.
    mv_kind = iv_kind.
    mt_name_mapping = it_name_mapping.
  ENDMETHOD.

  METHOD if_xco_json_transformation~get_visitor.
    ro_visitor = NEW lcl_visitor(
      io_tree_builder   = io_tree_builder
      io_transformation = me ).
  ENDMETHOD.

  METHOD converts_booleans.
    rv_converts = xsdbool( mv_kind = gc_kind-boolean_to_abap_bool ).
  ENDMETHOD.

  METHOD transform_name.
    CASE mv_kind.
      WHEN gc_kind-camel_case_to_underscore OR gc_kind-pascal_case_to_underscore.
        rv_name = to_underscore( iv_name ).
      WHEN gc_kind-underscore_to_camel_case.
        rv_name = from_underscore( iv_name        = iv_name
                                   iv_pascal_case = abap_false ).
      WHEN gc_kind-underscore_to_pascal_case.
        rv_name = from_underscore( iv_name        = iv_name
                                   iv_pascal_case = abap_true ).
      WHEN gc_kind-name_replacement.
        rv_name = replace_name( iv_name ).
      WHEN OTHERS.
        rv_name = iv_name.
    ENDCASE.
  ENDMETHOD.

  METHOD to_underscore.
    " an underscore separates a lower case letter or digit from a following upper case letter,
    " so orderId, OrderId and orderID become ORDER_ID and ORDER_ID stays as it is
    DATA lv_after_lower TYPE abap_bool.

    DATA(lv_length) = strlen( iv_name ).
    DO lv_length TIMES.
      DATA(lv_char) = substring( val = iv_name
                                 off = sy-index - 1
                                 len = 1 ).
      IF lv_after_lower = abap_true AND to_lower( lv_char ) <> lv_char.
        rv_name = rv_name && '_'.
      ENDIF.
      rv_name = rv_name && to_upper( lv_char ).
      lv_after_lower = xsdbool( to_upper( lv_char ) <> lv_char OR lv_char CO '0123456789' ).
    ENDDO.
  ENDMETHOD.

  METHOD from_underscore.
    DATA(lv_upper) = iv_pascal_case.
    DATA(lv_length) = strlen( iv_name ).
    DO lv_length TIMES.
      DATA(lv_char) = substring( val = iv_name
                                 off = sy-index - 1
                                 len = 1 ).
      IF lv_char = '_'.
        lv_upper = abap_true.
      ELSEIF lv_upper = abap_true.
        rv_name = rv_name && to_upper( lv_char ).
        lv_upper = abap_false.
      ELSE.
        rv_name = rv_name && to_lower( lv_char ).
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD replace_name.
    rv_name = iv_name.
    READ TABLE mt_name_mapping INTO DATA(ls_mapping) WITH KEY old_name = iv_name.
    IF sy-subrc = 0.
      rv_name = ls_mapping-new_name.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_visitor IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    mo_tree_builder = io_tree_builder.
    mo_transformation = io_transformation.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~enter_object.
    mo_tree_builder->begin_object( ).
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~leave_object.
    mo_tree_builder->end_object( ).
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~enter_array.
    mo_tree_builder->begin_array( ).
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~leave_array.
    mo_tree_builder->end_array( ).
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~visit_member.
    mo_tree_builder->add_member( mo_transformation->transform_name( iv_name ) ).
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~visit_string.
    mo_tree_builder->add_string( iv_value ).
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~visit_number.
    mo_tree_builder->add_number( iv_value ).
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~visit_boolean.
    IF mo_transformation->converts_booleans( ) = abap_false.
      mo_tree_builder->add_boolean( iv_value ).
    ELSEIF iv_value = abap_true.
      mo_tree_builder->add_string( abap_true ).
    ELSE.
      mo_tree_builder->add_string( `` ).
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~visit_null.
    mo_tree_builder->add_null( ).
  ENDMETHOD.
ENDCLASS.
