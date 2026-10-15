CLASS ltcl_cell DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS transformation FOR TESTING.
    METHODS unbound_field FOR TESTING.
    METHODS overwrite_and_clear FOR TESTING.
ENDCLASS.

CLASS ltcl_cell IMPLEMENTATION.
  METHOD transformation.
    DATA lv_flag TYPE abap_bool.
    DATA lv_text TYPE string.

    DATA(lo_document) = xco_cp_xlsx=>document->empty( )->write_access( ).
    DATA(lo_workbook) = lo_document->get_workbook( ).
    DATA(lo_cell) = lo_workbook->worksheet->at_position( 1 )->cursor(
      io_column = xco_cp_xlsx=>coordinate->for_numeric_value( 1 )
      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 1 ) )->get_cell( ).
    lo_cell->value->set_transformation( xco_cp_xlsx_write_access=>value_transformation->best_effort
      )->write_from( abap_true ).

    DATA(lo_read_workbook) = xco_cp_xlsx=>document->for_file_content( lo_document->get_file_content( )
      )->read_access( )->get_workbook( ).
    DATA(lo_value) = lo_read_workbook->worksheet->at_position( 1 )->cursor(
      io_column = xco_cp_xlsx=>coordinate->for_numeric_value( 1 )
      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 1 ) )->get_cell( )->get_value( ).

    lo_value->write_to( REF #( lv_flag ) ).
    cl_abap_unit_assert=>assert_equals( act = lv_flag
                                        exp = abap_true ).
    lo_value->set_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value )->write_to( REF #( lv_text ) ).
    cl_abap_unit_assert=>assert_equals( act = lv_text
                                        exp = `TRUE` ).
    lo_value->set_transformation( xco_cp_xlsx_read_access=>value_transformation->identity )->write_to( REF #( lv_text ) ).
    cl_abap_unit_assert=>assert_equals( act = lv_text
                                        exp = `1` ).
  ENDMETHOD.

  METHOD unbound_field.
    DATA lr_unbound TYPE REF TO data.

    DATA(lo_document) = xco_cp_xlsx=>document->empty( )->write_access( ).
    DATA(lo_workbook) = lo_document->get_workbook( ).
    DATA(lo_cell) = lo_workbook->worksheet->at_position( 1 )->cursor(
      io_column = xco_cp_xlsx=>coordinate->for_numeric_value( 1 )
      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 1 ) )->get_cell( ).
    lo_cell->value->write_from( 1 ).

    DATA(lo_read_workbook) = xco_cp_xlsx=>document->for_file_content( lo_document->get_file_content( )
      )->read_access( )->get_workbook( ).
    DATA(lo_value) = lo_read_workbook->worksheet->at_position( 1 )->cursor(
      io_column = xco_cp_xlsx=>coordinate->for_numeric_value( 1 )
      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 1 ) )->get_cell( )->get_value( ).
    TRY.
        lo_value->write_to( lr_unbound ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD overwrite_and_clear.
    DATA(lo_document) = xco_cp_xlsx=>document->empty( )->write_access( ).
    DATA(lo_workbook) = lo_document->get_workbook( ).
    DATA(lo_cursor) = lo_workbook->worksheet->at_position( 1 )->cursor(
      io_column = xco_cp_xlsx=>coordinate->for_numeric_value( 1 )
      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 1 ) ).
    DATA(lo_cell) = lo_cursor->get_cell( ).
    lo_cell->value->write_from( `old` ).
    lo_cell->value->write_from( 42 ).
    lo_cell = lo_cursor->move_down( )->get_cell( ).
    lo_cell->value->write_from( `gone` ).
    lo_cell->value->write_from( `` ).

    DATA(lo_file) = cl_xco_xlsx_file=>load( lo_document->get_file_content( ) ).
    cl_abap_unit_assert=>assert_equals( act = lo_file->mt_cells
                                        exp = VALUE cl_xco_xlsx_file=>ty_cells( ( sheet  = 1
                                                                                  row    = 1
                                                                                  column = 1
                                                                                  type   = cl_xco_xlsx_file=>gc_type-number
                                                                                  value  = `42` ) ) ).
  ENDMETHOD.
ENDCLASS.
