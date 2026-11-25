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
