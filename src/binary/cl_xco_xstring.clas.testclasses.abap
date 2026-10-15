CLASS ltcl_xco_xstring DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS value FOR TESTING.
    METHODS as_string FOR TESTING.
ENDCLASS.

CLASS ltcl_xco_xstring IMPLEMENTATION.
  METHOD value.
    DATA(lv_bytes) = CONV xstring( 'CAFE' ).

    DATA(lo_xstring) = xco_cp=>xstring( lv_bytes ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_xstring->value
      exp = lv_bytes ).
  ENDMETHOD.

  METHOD as_string.
    DATA(lo_string) = xco_cp=>xstring( CONV #( '536F6D6520737472696E67' ) )->as_string( xco_cp_character=>code_page->utf_8 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_string->value
      exp = `Some string` ).
  ENDMETHOD.
ENDCLASS.
