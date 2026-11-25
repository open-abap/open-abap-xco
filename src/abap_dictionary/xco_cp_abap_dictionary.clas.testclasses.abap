CLASS ltcl_xco_cp_abap_dictionary DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS object_name FOR TESTING.
    METHODS database_table FOR TESTING.
    METHODS key_field_names FOR TESTING.
    METHODS dynamic_key_field_names FOR TESTING.
ENDCLASS.

CLASS ltcl_xco_cp_abap_dictionary IMPLEMENTATION.
  METHOD object_name.
    DATA lv_name TYPE sxco_ad_object_name.

    lv_name = 'ZDEMO_DTEL'.

    cl_abap_unit_assert=>assert_equals(
      act = lv_name
      exp = 'ZDEMO_DTEL' ).
    cl_abap_unit_assert=>assert_equals(
      act = strlen( CONV sxco_ad_object_name( repeat( val = 'A' occ = 40 ) ) )
      exp = 30 ).
  ENDMETHOD.

  METHOD database_table.
    DATA(lo_database_table) = xco_cp_abap_dictionary=>database_table( 'ZDEMO_TABLE' ).

    cl_abap_unit_assert=>assert_bound( lo_database_table ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_database_table->name
      exp = 'ZDEMO_TABLE' ).
  ENDMETHOD.

  METHOD key_field_names.
    DATA(lo_database_table) = xco_cp_abap_dictionary=>database_table( 'T100' ).

    DATA(lt_names) = lo_database_table->fields->key->get_names( ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_names
      exp = VALUE sxco_t_ad_field_names(
        ( 'SPRSL' )
        ( 'ARBGB' )
        ( 'MSGNR' ) ) ).
  ENDMETHOD.

  METHOD dynamic_key_field_names.
    DATA lv_tabname TYPE sxco_dbt_object_name VALUE 'T100'.
    DATA lo_object TYPE REF TO object.
    DATA lt_names TYPE sxco_t_ad_field_names.
    FIELD-SYMBOLS <lv_value> TYPE any.

    CALL METHOD ('XCO_CP_ABAP_DICTIONARY')=>database_table
      EXPORTING
        iv_name           = lv_tabname
      RECEIVING
        ro_database_table = lo_object.
    ASSIGN lo_object->('IF_XCO_DATABASE_TABLE~FIELDS->IF_XCO_DBT_FIELDS_FACTORY~KEY') TO <lv_value>.
    cl_abap_unit_assert=>assert_subrc( ).

    lo_object = <lv_value>.
    CALL METHOD lo_object->('IF_XCO_DBT_FIELDS~GET_NAMES')
      RECEIVING
        rt_names = lt_names.

    cl_abap_unit_assert=>assert_equals(
      act = lt_names
      exp = VALUE sxco_t_ad_field_names(
        ( 'SPRSL' )
        ( 'ARBGB' )
        ( 'MSGNR' ) ) ).
  ENDMETHOD.
ENDCLASS.

* Fixtures: test/fixtures, ZXCOT_*
CLASS ltcl_data_element DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS existing FOR TESTING.
    METHODS missing FOR TESTING.
    METHODS domain_backed FOR TESTING.
    METHODS built_in_type FOR TESTING.
    METHODS underlying_built_in_types FOR TESTING.
    METHODS on_premise_entry_point FOR TESTING.
    METHODS built_in_type_clnt FOR TESTING.
    METHODS built_in_type_even_dec FOR TESTING.
ENDCLASS.

CLASS ltcl_data_element IMPLEMENTATION.
  METHOD existing.
    DATA(lo_data_element) = xco_cp_abap_dictionary=>data_element( 'ZXCOT_STATUS_CODE' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data_element->name
      exp = 'ZXCOT_STATUS_CODE' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_data_element->exists( )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_bound( lo_data_element->content( ) ).
  ENDMETHOD.

  METHOD missing.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_abap_dictionary=>data_element( 'ZXCOT_MISSING' )->exists( )
      exp = abap_false ).
  ENDMETHOD.

  METHOD domain_backed.
* the domain name differs from the data element name
    DATA(lo_data_type) = xco_cp_abap_dictionary=>data_element( 'ZXCOT_STATUS_CODE' )->content( )->get_data_type( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data_type->is_domain( )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_data_type->is_built_in_type( )
      exp = abap_false ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_data_type->get_domain( )->name
      exp = 'ZXCOT_STATUS' ).
  ENDMETHOD.

  METHOD built_in_type.
    DATA(lo_data_type) = xco_cp_abap_dictionary=>data_element( 'ZXCOT_TEXT' )->content( )->get_data_type( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data_type->is_domain( )
      exp = abap_false ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_data_type->is_built_in_type( )
      exp = abap_true ).

    DATA(lo_built_in_type) = lo_data_type->get_built_in_type( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_built_in_type->type
      exp = 'CHAR' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_built_in_type->length
      exp = 40 ).
  ENDMETHOD.

  METHOD underlying_built_in_types.
* via the domain CHAR 1, and directly CHAR 40
    DATA(lo_content) = xco_cp_abap_dictionary=>data_element( 'ZXCOT_STATUS_CODE' )->content( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_content->has_underlying_built_in_type( )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_content->get_underlying_built_in_type( )->length
      exp = 1 ).

    lo_content = xco_cp_abap_dictionary=>data_element( 'ZXCOT_TEXT' )->content( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_content->has_underlying_built_in_type( )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_content->get_underlying_built_in_type( )->length
      exp = 40 ).
  ENDMETHOD.

  METHOD built_in_type_clnt.
* CLNT, not CHAR, both are character-like with the same runtime type
    DATA(lo_built_in_type) = xco_cp_abap_dictionary=>data_element( 'ZXCOT_CLIENT'
      )->content( )->get_data_type( )->get_built_in_type( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_built_in_type->type
      exp = 'CLNT' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_built_in_type->length
      exp = 3 ).
  ENDMETHOD.

  METHOD built_in_type_even_dec.
* DEC 4 and DEC 5 have the same packed runtime length, the DDIC length is 4
    DATA(lo_built_in_type) = xco_cp_abap_dictionary=>data_element( 'ZXCOT_AMOUNT'
      )->content( )->get_data_type( )->get_built_in_type( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_built_in_type->type
      exp = 'DEC' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_built_in_type->length
      exp = 4 ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_built_in_type->decimals
      exp = 2 ).
  ENDMETHOD.

  METHOD on_premise_entry_point.
    DATA(lo_data_type) = xco_abap_dictionary=>data_element( 'ZXCOT_STATUS_CODE' )->content( )->get_data_type( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data_type->is_domain( )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_data_type->get_domain( )->name
      exp = 'ZXCOT_STATUS' ).
    cl_abap_unit_assert=>assert_equals(
      act = xco_abap_dictionary=>data_element( 'ZXCOT_MISSING' )->exists( )
      exp = abap_false ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_table_type DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS existing FOR TESTING.
    METHODS missing FOR TESTING.
    METHODS row_data_element FOR TESTING.
    METHODS row_structure FOR TESTING.
    METHODS row_table_type FOR TESTING.
    METHODS row_interface FOR TESTING.
    METHODS row_class FOR TESTING.

    METHODS get_row_type
      IMPORTING
        iv_name            TYPE sxco_ad_object_name
      RETURNING
        VALUE(ro_row_type) TYPE REF TO if_xco_ttyp_row_type.

    METHODS row_kinds
      IMPORTING
        io_row_type     TYPE REF TO if_xco_ttyp_row_type
      RETURNING
        VALUE(rt_kinds) TYPE string_table.
ENDCLASS.

CLASS ltcl_table_type IMPLEMENTATION.
  METHOD get_row_type.
    ro_row_type = xco_cp_abap_dictionary=>table_type( iv_name )->content( )->get_row_type( ).
    cl_abap_unit_assert=>assert_bound( ro_row_type ).
  ENDMETHOD.

  METHOD row_kinds.
* every is_* predicate that holds, so each test also checks that the others do not
    IF io_row_type->is_data_element( ) = abap_true.
      APPEND `DATA_ELEMENT` TO rt_kinds.
    ENDIF.
    IF io_row_type->is_structure( ) = abap_true.
      APPEND `STRUCTURE` TO rt_kinds.
    ENDIF.
    IF io_row_type->is_table_type( ) = abap_true.
      APPEND `TABLE_TYPE` TO rt_kinds.
    ENDIF.
    IF io_row_type->is_interface( ) = abap_true.
      APPEND `INTERFACE` TO rt_kinds.
    ENDIF.
    IF io_row_type->is_class( ) = abap_true.
      APPEND `CLASS` TO rt_kinds.
    ENDIF.
  ENDMETHOD.

  METHOD existing.
    DATA(lo_table_type) = xco_cp_abap_dictionary=>table_type( 'ZXCOT_T_TEXT' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_table_type->name
      exp = 'ZXCOT_T_TEXT' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_table_type->exists( )
      exp = abap_true ).
  ENDMETHOD.

  METHOD missing.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_abap_dictionary=>table_type( 'ZXCOT_T_MISSING' )->exists( )
      exp = abap_false ).
  ENDMETHOD.

  METHOD row_data_element.
    DATA(lo_row_type) = get_row_type( 'ZXCOT_T_TEXT' ).

    cl_abap_unit_assert=>assert_equals(
      act = row_kinds( lo_row_type )
      exp = VALUE string_table( ( `DATA_ELEMENT` ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_row_type->get_data_element( )->name
      exp = 'ZXCOT_TEXT' ).
  ENDMETHOD.

  METHOD row_structure.
    DATA(lo_row_type) = get_row_type( 'ZXCOT_T_ROW' ).

    cl_abap_unit_assert=>assert_equals(
      act = row_kinds( lo_row_type )
      exp = VALUE string_table( ( `STRUCTURE` ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_row_type->get_structure( )->name
      exp = 'ZXCOT_S_ROW' ).
  ENDMETHOD.

  METHOD row_table_type.
    DATA(lo_row_type) = get_row_type( 'ZXCOT_T_NESTED' ).

    cl_abap_unit_assert=>assert_equals(
      act = row_kinds( lo_row_type )
      exp = VALUE string_table( ( `TABLE_TYPE` ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_row_type->get_table_type( )->name
      exp = 'ZXCOT_T_TEXT' ).
  ENDMETHOD.

  METHOD row_interface.
    DATA(lo_row_type) = get_row_type( 'ZXCOT_T_INTF_REF' ).

    cl_abap_unit_assert=>assert_equals(
      act = row_kinds( lo_row_type )
      exp = VALUE string_table( ( `INTERFACE` ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_row_type->get_interface( )->name
      exp = 'ZIF_XCOT_MARKER' ).
  ENDMETHOD.

  METHOD row_class.
    DATA(lo_row_type) = get_row_type( 'ZXCOT_T_CLAS_REF' ).

    cl_abap_unit_assert=>assert_equals(
      act = row_kinds( lo_row_type )
      exp = VALUE string_table( ( `CLASS` ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_row_type->get_class( )->name
      exp = 'ZCL_XCOT_MARKER' ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_structure DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS existing FOR TESTING.
    METHODS missing FOR TESTING.
    METHODS short_description FOR TESTING.
    METHODS component_names FOR TESTING.
    METHODS component_data_elements FOR TESTING.
    METHODS component_built_in_type FOR TESTING.
    METHODS via_table_type_row FOR TESTING.
ENDCLASS.

CLASS ltcl_structure IMPLEMENTATION.
  METHOD existing.
    DATA(lo_structure) = xco_cp_abap_dictionary=>structure( 'ZXCOT_S_ROW' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_structure->name
      exp = 'ZXCOT_S_ROW' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_structure->exists( )
      exp = abap_true ).
  ENDMETHOD.

  METHOD missing.
    DATA(lo_structure) = xco_cp_abap_dictionary=>structure( 'ZXCOT_S_MISSING' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_structure->exists( )
      exp = abap_false ).
    cl_abap_unit_assert=>assert_initial( lo_structure->components->all->get( ) ).
  ENDMETHOD.

  METHOD short_description.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_abap_dictionary=>structure( 'ZXCOT_S_ROW' )->content( )->get_short_description( )
      exp = 'XCO test row structure' ).
  ENDMETHOD.

  METHOD component_names.
* in declaration order
    DATA lt_names TYPE string_table.

    LOOP AT xco_cp_abap_dictionary=>structure( 'ZXCOT_S_ROW' )->components->all->get( ) INTO DATA(lo_component).
      APPEND to_upper( lo_component->name ) TO lt_names.
    ENDLOOP.

    cl_abap_unit_assert=>assert_equals(
      act = lt_names
      exp = VALUE string_table(
        ( `NAME` )
        ( `STATUS` )
        ( `POSITION` ) ) ).
  ENDMETHOD.

  METHOD component_data_elements.
    DATA(lt_components) = xco_cp_abap_dictionary=>structure( 'ZXCOT_S_ROW' )->components->all->get( ).

    DATA(lo_type) = lt_components[ 1 ]->content( )->get_type( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->is_data_element( )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->is_built_in_type( )
      exp = abap_false ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->get_data_element( )->name
      exp = 'ZXCOT_TEXT' ).

* the type in get( ) is the same as get_type( )
    cl_abap_unit_assert=>assert_equals(
      act = lt_components[ 2 ]->content( )->get( )-type->get_data_element( )->name
      exp = 'ZXCOT_STATUS_CODE' ).
  ENDMETHOD.

  METHOD component_built_in_type.
    DATA(lt_components) = xco_cp_abap_dictionary=>structure( 'ZXCOT_S_ROW' )->components->all->get( ).

    DATA(lo_type) = lt_components[ 3 ]->content( )->get_type( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->is_data_element( )
      exp = abap_false ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_type->is_built_in_type( )
      exp = abap_true ).

    DATA(lo_built_in) = lo_type->get_built_in_type( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_built_in->type
      exp = 'NUMC' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_built_in->length
      exp = 4 ).
  ENDMETHOD.

  METHOD via_table_type_row.
    DATA(lo_structure) = xco_cp_abap_dictionary=>table_type( 'ZXCOT_T_ROW' )->content( )->get_row_type( )->get_structure( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lo_structure->components->all->get( ) )
      exp = 3 ).
  ENDMETHOD.
ENDCLASS.
