CLASS ltcl_xco_language DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS value FOR TESTING.
    METHODS descriptions FOR TESTING.
ENDCLASS.

CLASS ltcl_xco_language IMPLEMENTATION.
  METHOD value.
    DATA(lo_language) = NEW cl_xco_language( 'E' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_language->if_xco_language~value
      exp = 'E' ).
  ENDMETHOD.

  METHOD descriptions.
    DATA(lo_language) = NEW cl_xco_language( 'D' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_language->if_xco_language~get_name( )
      exp = 'German' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_language->if_xco_language~get_long_text_description( )
      exp = 'German, Germany' ).
  ENDMETHOD.
ENDCLASS.
