CLASS ltcl_code_page DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS utf_8_encode FOR TESTING.
    METHODS utf_8_decode FOR TESTING.
    METHODS utf_8_multi_byte FOR TESTING.
    METHODS utf_8_broken FOR TESTING.
    METHODS for_name FOR TESTING.
    METHODS text FOR TESTING.
ENDCLASS.

CLASS ltcl_code_page IMPLEMENTATION.
  METHOD utf_8_encode.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_character=>code_page->utf_8->if_xco_string_xstring_cnvrsn~apply( `Hello world` )
      exp = CONV xstring( '48656C6C6F20776F726C64' ) ).
  ENDMETHOD.

  METHOD utf_8_decode.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_character=>code_page->utf_8->if_xco_xstring_string_cnvrsn~apply( CONV #( '48656C6C6F20776F726C64' ) )
      exp = `Hello world` ).
  ENDMETHOD.

  METHOD utf_8_multi_byte.
    DATA(lo_text) = xco_cp=>xstring( CONV #( 'C3A9' ) )->as_string( xco_cp_character=>code_page->utf_8 ).

    cl_abap_unit_assert=>assert_equals(
      act = strlen( lo_text->value )
      exp = 1 ).

    DATA(lo_bytes) = lo_text->as_xstring( xco_cp_character=>code_page->utf_8 ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_bytes->value
      exp = CONV xstring( 'C3A9' ) ).
  ENDMETHOD.

  METHOD utf_8_broken.
    TRY.
        xco_cp=>xstring( CONV #( 'C3' ) )->as_string( xco_cp_character=>code_page->utf_8 ).
        cl_abap_unit_assert=>fail( 'An incomplete UTF-8 sequence was accepted' ).
      CATCH cx_xco_runtime_exception.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD for_name.
    DATA(lo_bytes) = xco_cp=>string( `ABAP` )->as_xstring( xco_cp_character=>code_page->for( `UTF-8` ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_bytes->value
      exp = CONV xstring( '41424150' ) ).
  ENDMETHOD.

  METHOD text.
    DATA(lo_lines) = xco_cp_character=>code_page->utf_8->if_xco_printable~get_text( )->get_lines( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_lines->value
      exp = VALUE string_table( ( `UTF-8` ) ) ).
  ENDMETHOD.
ENDCLASS.
