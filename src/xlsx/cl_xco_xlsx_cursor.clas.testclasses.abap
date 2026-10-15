CLASS ltcl_cursor DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_document TYPE REF TO if_xco_xlsx_wa_document.
    DATA mo_worksheet TYPE REF TO if_xco_xlsx_wa_worksheet.

    METHODS setup.

    METHODS write_and_read FOR TESTING.
    METHODS read_until_empty FOR TESTING.
    METHODS without_cell FOR TESTING.
    METHODS before_the_first_row FOR TESTING.
    METHODS beyond_the_last_column FOR TESTING.
    METHODS unbound_coordinates FOR TESTING.

    METHODS read_worksheet
      RETURNING
        VALUE(ro_worksheet) TYPE REF TO if_xco_xlsx_ra_worksheet.

    METHODS coordinate
      IMPORTING
        iv_value             TYPE string
      RETURNING
        VALUE(ro_coordinate) TYPE REF TO cl_xco_xlsx_coordinate.
ENDCLASS.

CLASS ltcl_cursor IMPLEMENTATION.
  METHOD setup.
    mo_document = xco_cp_xlsx=>document->empty( )->write_access( ).
    DATA(lo_workbook) = mo_document->get_workbook( ).
    mo_worksheet = lo_workbook->worksheet->at_position( 1 ).
  ENDMETHOD.

  METHOD write_and_read.
    " the example of the SAP Help Portal, "XLSX Write Access", "Writing Data via a Cursor"
    DATA lv_date TYPE d.
    DATA lv_text TYPE string.

    DATA(lo_cursor) = mo_worksheet->cursor( io_column = coordinate( `B` )
                                            io_row    = coordinate( `2` ) ).
    DATA(lo_cell) = lo_cursor->get_cell( ).
    lo_cell->value->write_from( 'Date:' ).
    lo_cell = lo_cursor->move_right( )->get_cell( ).
    lo_cell->value->write_from( CONV d( '20250120' ) ).
    lo_cell = lo_cursor->move_down( )->move_left( )->get_cell( ).
    lo_cell->value->write_from( 'Time:' ).
    lo_cell = lo_cursor->move_right( )->get_cell( ).
    lo_cell->value->write_from( CONV t( '120000' ) ).

    cl_abap_unit_assert=>assert_equals( act = lo_cursor->position->column->get_alphabetic_value( )
                                        exp = `C` ).
    cl_abap_unit_assert=>assert_equals( act = lo_cursor->position->row->get_numeric_value( )
                                        exp = 3 ).

    DATA(lo_read) = read_worksheet( )->cursor( io_column = coordinate( `C` )
                                               io_row    = coordinate( `2` ) ).
    lo_read->get_cell( )->get_value( )->write_to( REF #( lv_date ) ).
    cl_abap_unit_assert=>assert_equals( act = lv_date
                                        exp = '20250120' ).
    lo_read->move_down( )->move_left( )->get_cell( )->get_value( )->write_to( REF #( lv_text ) ).
    cl_abap_unit_assert=>assert_equals( act = lv_text
                                        exp = `Time:` ).
  ENDMETHOD.

  METHOD read_until_empty.
    " the example of the SAP Help Portal, "XLSX Read Access", "Accessing Data via a Cursor"
    DATA lt_values TYPE string_table.
    DATA lv_value TYPE string.

    DATA(lo_writer) = mo_worksheet->cursor( io_column = coordinate( `A` )
                                            io_row    = coordinate( `5` ) ).
    DO 3 TIMES.
      DATA(lo_cell) = lo_writer->get_cell( ).
      lo_cell->value->write_from( sy-index ).
      lo_writer->move_down( ).
    ENDDO.

    DATA(lo_cursor) = read_worksheet( )->cursor( io_column = coordinate( `A` )
                                                 io_row    = coordinate( `5` ) ).
    WHILE lo_cursor->has_cell( ) = abap_true AND lo_cursor->get_cell( )->has_value( ) = abap_true.
      lo_cursor->get_cell( )->get_value(
        )->set_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
        )->write_to( REF #( lv_value ) ).
      APPEND lv_value TO lt_values.
      lo_cursor->move_down( ).
    ENDWHILE.

    cl_abap_unit_assert=>assert_equals( act = lt_values
                                        exp = VALUE string_table( ( `1` ) ( `2` ) ( `3` ) ) ).
    cl_abap_unit_assert=>assert_equals( act = lo_cursor->position->row->get_numeric_value( )
                                        exp = 8 ).
  ENDMETHOD.

  METHOD without_cell.
    DATA(lo_cursor) = read_worksheet( )->cursor( io_column = coordinate( `A` )
                                                 io_row    = coordinate( `1` ) ).

    cl_abap_unit_assert=>assert_false( lo_cursor->has_cell( ) ).
    TRY.
        lo_cursor->get_cell( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD before_the_first_row.
    DATA(lo_cursor) = mo_worksheet->cursor( io_column = coordinate( `B` )
                                            io_row    = coordinate( `2` ) ).

    TRY.
        lo_cursor->move_up( 2 ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
    cl_abap_unit_assert=>assert_equals( act = lo_cursor->position->row->get_numeric_value( )
                                        exp = 2 ).
  ENDMETHOD.

  METHOD beyond_the_last_column.
    DATA(lo_cursor) = mo_worksheet->cursor( io_column = coordinate( `XFD` )
                                            io_row    = coordinate( `1` ) ).
    lo_cursor->move_right( ).
    DATA(lo_cell) = lo_cursor->get_cell( ).

    TRY.
        lo_cell->value->write_from( `outside` ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD unbound_coordinates.
    DATA lo_unbound TYPE REF TO cl_xco_xlsx_coordinate.

    TRY.
        mo_worksheet->cursor( io_column = lo_unbound
                              io_row    = coordinate( `1` ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    DATA(lo_cursor) = read_worksheet( )->cursor( io_column = coordinate( `A` )
                                                 io_row    = coordinate( `1` ) ).
    TRY.
        lo_cursor->set_row( lo_unbound ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
    TRY.
        lo_cursor->set_column( lo_unbound ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD read_worksheet.
    DATA(lo_workbook) = xco_cp_xlsx=>document->for_file_content( mo_document->get_file_content( )
      )->read_access( )->get_workbook( ).
    ro_worksheet = lo_workbook->worksheet->at_position( 1 ).
  ENDMETHOD.

  METHOD coordinate.
    IF iv_value CO '0123456789'.
      ro_coordinate = xco_cp_xlsx=>coordinate->for_numeric_value( CONV i( iv_value ) ).
    ELSE.
      ro_coordinate = xco_cp_xlsx=>coordinate->for_alphabetic_value( iv_value ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
