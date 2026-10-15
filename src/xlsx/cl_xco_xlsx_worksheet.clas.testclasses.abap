CLASS ltcl_worksheet DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_document TYPE REF TO if_xco_xlsx_wa_document.
    DATA mo_workbook TYPE REF TO if_xco_xlsx_wa_workbook.

    METHODS setup.

    METHODS exists FOR TESTING.
    METHODS set_name FOR TESTING.
    METHODS invalid_name FOR TESTING.
    METHODS missing_worksheet FOR TESTING.
    METHODS for_name_ignores_case FOR TESTING.

    METHODS read_workbook
      RETURNING
        VALUE(ro_workbook) TYPE REF TO if_xco_xlsx_ra_workbook.
ENDCLASS.

CLASS ltcl_worksheet IMPLEMENTATION.
  METHOD setup.
    mo_document = xco_cp_xlsx=>document->empty( )->write_access( ).
    mo_workbook = mo_document->get_workbook( ).
  ENDMETHOD.

  METHOD exists.
    cl_abap_unit_assert=>assert_true( mo_workbook->worksheet->at_position( 1 )->exists( ) ).
    cl_abap_unit_assert=>assert_false( mo_workbook->worksheet->at_position( 2 )->exists( ) ).
    cl_abap_unit_assert=>assert_false( mo_workbook->worksheet->at_position( 0 )->exists( ) ).

    DATA(lo_later) = mo_workbook->worksheet->at_position( 2 ).
    mo_workbook->add_new_sheet( ).
    cl_abap_unit_assert=>assert_true( lo_later->exists( ) ).
  ENDMETHOD.

  METHOD set_name.
    mo_workbook->worksheet->at_position( 1 )->set_name( `Renamed` ).

    DATA(lo_workbook) = read_workbook( ).
    cl_abap_unit_assert=>assert_true( lo_workbook->worksheet->for_name( `Renamed` )->exists( ) ).
    cl_abap_unit_assert=>assert_false( lo_workbook->worksheet->for_name( `Sheet1` )->exists( ) ).
  ENDMETHOD.

  METHOD invalid_name.
    mo_workbook->add_new_sheet( `Data` ).
    DATA(lo_first) = mo_workbook->worksheet->at_position( 1 ).

    DATA(lt_names) = VALUE string_table( ( `DATA` ) ( `a:b` ) ( `'quoted'` ) ( `History` ) ).
    LOOP AT lt_names INTO DATA(lv_name).
      TRY.
          lo_first->set_name( lv_name ).
          cl_abap_unit_assert=>fail( lv_name ).
        CATCH cx_xco_runtime_exception ##NO_HANDLER.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD missing_worksheet.
    DATA(lo_worksheet) = mo_workbook->worksheet->at_position( 2 ).

    TRY.
        lo_worksheet->set_name( `Two` ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
    TRY.
        lo_worksheet->select( xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
    TRY.
        lo_worksheet->cursor( io_column = xco_cp_xlsx=>coordinate->for_numeric_value( 1 )
                              io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 1 ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD for_name_ignores_case.
    mo_workbook->add_new_sheet( `Data` ).

    DATA(lo_workbook) = read_workbook( ).
    cl_abap_unit_assert=>assert_true( lo_workbook->worksheet->for_name( `DATA` )->exists( ) ).
    cl_abap_unit_assert=>assert_false( lo_workbook->worksheet->for_name( `Missing` )->exists( ) ).
  ENDMETHOD.

  METHOD read_workbook.
    ro_workbook = xco_cp_xlsx=>document->for_file_content( mo_document->get_file_content( )
      )->read_access( )->get_workbook( ).
  ENDMETHOD.
ENDCLASS.
