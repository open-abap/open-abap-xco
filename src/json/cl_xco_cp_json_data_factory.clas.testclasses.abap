CLASS ltcl_json_data_factory DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS from_string FOR TESTING.
    METHODS from_abap FOR TESTING.
    METHODS builder FOR TESTING.
ENDCLASS.

CLASS ltcl_json_data_factory IMPLEMENTATION.
  METHOD from_string.
    DATA(lo_data) = xco_cp_json=>data->from_string( '{"text":"hello"}' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data->to_string( )
      exp = '{"text":"hello"}' ).
  ENDMETHOD.

  METHOD from_abap.
    TYPES:
      BEGIN OF ty_data,
        text   TYPE string,
        number TYPE i,
      END OF ty_data.

    DATA(ls_data) = VALUE ty_data( text = 'hello' number = 42 ).
    DATA(lo_data) = xco_cp_json=>data->from_abap( ls_data ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data->to_string( )
      exp = '{"TEXT":"hello","NUMBER":42}' ).
  ENDMETHOD.

  METHOD builder.
    DATA(lo_builder) = xco_cp_json=>data->builder( ).

    lo_builder->begin_object(
      )->add_member( 'text'
      )->add_string( 'hello'
      )->add_member( 'valid'
      )->add_boolean( abap_true
      )->add_member( 'numbers'
      )->begin_array(
      )->add_number( 1
      )->add_number( 2
      )->end_array(
      )->end_object( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_builder->get_data( )->to_string( )
      exp = '{"text":"hello","valid":true,"numbers":[1,2]}' ).
  ENDMETHOD.
ENDCLASS.
