CLASS ltcl_pattern DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS unbounded FOR TESTING.
    METHODS bounded FOR TESTING.
    METHODS builder_changes_no_pattern FOR TESTING.
    METHODS from_after_to FOR TESTING.

    METHODS bounds_of
      IMPORTING
        io_pattern       TYPE REF TO if_xco_xlsx_slc_pattern
      RETURNING
        VALUE(rs_bounds) TYPE cl_xco_xlsx_slc_pattern=>ty_bounds.
ENDCLASS.

CLASS ltcl_pattern IMPLEMENTATION.
  METHOD unbounded.
    DATA(lo_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

    cl_abap_unit_assert=>assert_equals(
      act = bounds_of( lo_pattern )
      exp = VALUE cl_xco_xlsx_slc_pattern=>ty_bounds( from_column = 1
                                                      to_column   = cl_xco_xlsx_slc_pattern=>gc_unbounded
                                                      from_row    = 1
                                                      to_row      = cl_xco_xlsx_slc_pattern=>gc_unbounded ) ).
  ENDMETHOD.

  METHOD bounded.
    DATA(lo_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
      )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'C' )
      )->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'D' )
      )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 3 )
      )->to_row( xco_cp_xlsx=>coordinate->for_numeric_value( 4 )
      )->get_pattern( ).

    cl_abap_unit_assert=>assert_equals(
      act = bounds_of( lo_pattern )
      exp = VALUE cl_xco_xlsx_slc_pattern=>ty_bounds( from_column = 3
                                                      to_column   = 4
                                                      from_row    = 3
                                                      to_row      = 4 ) ).
  ENDMETHOD.

  METHOD builder_changes_no_pattern.
    DATA(lo_builder) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( ).
    DATA(lo_pattern) = lo_builder->get_pattern( ).

    lo_builder->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 ) ).

    cl_abap_unit_assert=>assert_equals( act = bounds_of( lo_pattern )-from_row
                                        exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = bounds_of( lo_builder->get_pattern( ) )-from_row
                                        exp = 2 ).
  ENDMETHOD.

  METHOD from_after_to.
    TRY.
        xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
          )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 5 )
          )->to_row( xco_cp_xlsx=>coordinate->for_numeric_value( 4 )
          )->get_pattern( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD bounds_of.
    rs_bounds = CAST cl_xco_xlsx_slc_pattern( io_pattern->get_implementation( ) )->get_bounds( ).
  ENDMETHOD.
ENDCLASS.
