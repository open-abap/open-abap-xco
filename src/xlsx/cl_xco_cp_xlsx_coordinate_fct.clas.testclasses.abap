CLASS ltcl_coordinate_factory DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES ty_integers TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    METHODS numeric FOR TESTING.
    METHODS alphabetic FOR TESTING.
    METHODS alphabetic_lower_case FOR TESTING.
    METHODS invalid_numeric FOR TESTING.
    METHODS invalid_alphabetic FOR TESTING.

    METHODS assert_alphabetic
      IMPORTING
        iv_alphabetic TYPE string
        iv_numeric    TYPE i.
ENDCLASS.

CLASS ltcl_coordinate_factory IMPLEMENTATION.
  METHOD numeric.
    DATA(lo_coordinate) = xco_cp_xlsx=>coordinate->for_numeric_value( 27 ).

    cl_abap_unit_assert=>assert_equals( act = lo_coordinate->get_numeric_value( )
                                        exp = 27 ).
    cl_abap_unit_assert=>assert_equals( act = lo_coordinate->get_alphabetic_value( )
                                        exp = `AA` ).
  ENDMETHOD.

  METHOD alphabetic.
    assert_alphabetic( iv_alphabetic = `A`
                       iv_numeric    = 1 ).
    assert_alphabetic( iv_alphabetic = `Z`
                       iv_numeric    = 26 ).
    assert_alphabetic( iv_alphabetic = `AA`
                       iv_numeric    = 27 ).
    assert_alphabetic( iv_alphabetic = `AZ`
                       iv_numeric    = 52 ).
    assert_alphabetic( iv_alphabetic = `ZZ`
                       iv_numeric    = 702 ).
    assert_alphabetic( iv_alphabetic = `AAA`
                       iv_numeric    = 703 ).
    assert_alphabetic( iv_alphabetic = `XFD`
                       iv_numeric    = 16384 ).
  ENDMETHOD.

  METHOD alphabetic_lower_case.
    cl_abap_unit_assert=>assert_equals( act = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'ab' )->get_numeric_value( )
                                        exp = 28 ).
  ENDMETHOD.

  METHOD invalid_numeric.
    " 1 to 1048576, the rows of a worksheet
    cl_abap_unit_assert=>assert_equals( act = xco_cp_xlsx=>coordinate->for_numeric_value( 1048576 )->get_numeric_value( )
                                        exp = 1048576 ).

    DATA(lt_values) = VALUE ty_integers( ( 0 ) ( -1 ) ( 1048577 ) ).
    LOOP AT lt_values INTO DATA(lv_value).
      TRY.
          xco_cp_xlsx=>coordinate->for_numeric_value( lv_value ).
          cl_abap_unit_assert=>fail( ).
        CATCH cx_xco_runtime_exception ##NO_HANDLER.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD invalid_alphabetic.
    DATA(lt_values) = VALUE string_table( ( `` ) ( `A1` ) ( `1` ) ( `A-B` ) ( `AAAA` ) ( `XFE` ) ).

    LOOP AT lt_values INTO DATA(lv_value).
      TRY.
          xco_cp_xlsx=>coordinate->for_alphabetic_value( lv_value ).
          cl_abap_unit_assert=>fail( lv_value ).
        CATCH cx_xco_runtime_exception ##NO_HANDLER.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD assert_alphabetic.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_xlsx=>coordinate->for_alphabetic_value( iv_alphabetic )->get_numeric_value( )
      exp = iv_numeric
      msg = iv_alphabetic ).
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_xlsx=>coordinate->for_numeric_value( iv_numeric )->get_alphabetic_value( )
      exp = iv_alphabetic
      msg = iv_alphabetic ).
  ENDMETHOD.
ENDCLASS.
