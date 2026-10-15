CLASS ltcl_write_access DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS empty_document FOR TESTING.
    METHODS add_new_sheet FOR TESTING.
ENDCLASS.

CLASS ltcl_write_access IMPLEMENTATION.
  METHOD empty_document.
    " one worksheet named Sheet1, see the SAP Help Portal, "XLSX Write Access"
    DATA(lo_document) = xco_cp_xlsx=>document->empty( )->write_access( ).

    DATA(lo_file) = cl_xco_xlsx_file=>load( lo_document->get_file_content( ) ).
    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_count( )
                                        exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `Sheet1` )
                                        exp = 1 ).
  ENDMETHOD.

  METHOD add_new_sheet.
    DATA(lo_document) = xco_cp_xlsx=>document->empty( )->write_access( ).
    DATA(lo_workbook) = lo_document->get_workbook( ).
    DATA(lo_second) = lo_workbook->add_new_sheet( ).
    DATA(lo_third) = lo_workbook->add_new_sheet( `Data` ).
    DATA(lo_cell) = lo_third->cursor( io_column = xco_cp_xlsx=>coordinate->for_numeric_value( 1 )
                                      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 1 ) )->get_cell( ).
    lo_cell->value->write_from( `on the third sheet` ).

    DATA(lo_file) = cl_xco_xlsx_file=>load( lo_document->get_file_content( ) ).
    cl_abap_unit_assert=>assert_true( lo_second->exists( ) ).
    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `Sheet2` )
                                        exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `Data` )
                                        exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = lo_file->mt_cells[ 1 ]-sheet
                                        exp = 3 ).
  ENDMETHOD.
ENDCLASS.
