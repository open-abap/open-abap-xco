CLASS ltcl_read_access DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS worksheets FOR TESTING.
    METHODS invalid_content FOR TESTING.
ENDCLASS.

CLASS ltcl_read_access IMPLEMENTATION.
  METHOD worksheets.
    DATA(lo_document) = xco_cp_xlsx=>document->empty( )->write_access( ).
    DATA(lo_write_workbook) = lo_document->get_workbook( ).
    lo_write_workbook->add_new_sheet( `Second` ).

    DATA(lo_workbook) = xco_cp_xlsx=>document->for_file_content( lo_document->get_file_content( )
      )->read_access( )->get_workbook( ).

    cl_abap_unit_assert=>assert_true( lo_workbook->worksheet->for_name( `Sheet1` )->exists( ) ).
    cl_abap_unit_assert=>assert_true( lo_workbook->worksheet->for_name( `second` )->exists( ) ).
    cl_abap_unit_assert=>assert_true( lo_workbook->worksheet->at_position( 2 )->exists( ) ).
    cl_abap_unit_assert=>assert_false( lo_workbook->worksheet->at_position( 3 )->exists( ) ).
    cl_abap_unit_assert=>assert_false( lo_workbook->worksheet->for_name( `Missing` )->exists( ) ).
  ENDMETHOD.

  METHOD invalid_content.
    DATA(lo_document) = xco_cp_xlsx=>document->for_file_content( CONV xstring( 'FFFEFDFC' ) ).

    TRY.
        lo_document->read_access( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
