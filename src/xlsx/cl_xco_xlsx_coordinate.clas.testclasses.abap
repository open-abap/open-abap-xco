CLASS ltcl_coordinate DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS shift FOR TESTING.
    METHODS shift_keeps_original FOR TESTING.
    METHODS shift_before_first FOR TESTING.
    METHODS shift_beyond_last FOR TESTING.
ENDCLASS.

CLASS ltcl_coordinate IMPLEMENTATION.
  METHOD shift.
    DATA(lo_coordinate) = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'Z' ).

    cl_abap_unit_assert=>assert_equals( act = lo_coordinate->shift( 2 )->get_alphabetic_value( )
                                        exp = `AB` ).
    cl_abap_unit_assert=>assert_equals( act = lo_coordinate->shift( -25 )->get_numeric_value( )
                                        exp = 1 ).
  ENDMETHOD.

  METHOD shift_keeps_original.
    DATA(lo_coordinate) = xco_cp_xlsx=>coordinate->for_numeric_value( 5 ).

    lo_coordinate->shift( 1 ).

    cl_abap_unit_assert=>assert_equals( act = lo_coordinate->get_numeric_value( )
                                        exp = 5 ).
  ENDMETHOD.

  METHOD shift_before_first.
    TRY.
        xco_cp_xlsx=>coordinate->for_numeric_value( 1 )->shift( -1 ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD shift_beyond_last.
    DATA(lo_coordinate) = xco_cp_xlsx=>coordinate->for_numeric_value( 1048576 ).

    TRY.
        lo_coordinate->shift( 1 ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
    TRY.
        lo_coordinate->shift( 2147483647 ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
