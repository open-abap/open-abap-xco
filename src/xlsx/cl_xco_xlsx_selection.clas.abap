" the cells of a worksheet that a pattern selects, with its streams, for read and write access
CLASS cl_xco_xlsx_selection DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_xlsx_worksheet.

  PUBLIC SECTION.
    INTERFACES if_xco_xlsx_ra_selection.
    INTERFACES if_xco_xlsx_ra_row_stream.
    INTERFACES if_xco_xlsx_ra_rs_operation_fc.
    INTERFACES if_xco_xlsx_ra_cell_stream.
    INTERFACES if_xco_xlsx_ra_cs_operation_fc.
    INTERFACES if_xco_xlsx_wa_selection.
    INTERFACES if_xco_xlsx_wa_row_stream.
    INTERFACES if_xco_xlsx_wa_rs_operation_fc.

    METHODS constructor
      IMPORTING
        io_file   TYPE REF TO cl_xco_xlsx_file
        iv_sheet  TYPE i
        is_bounds TYPE cl_xco_xlsx_slc_pattern=>ty_bounds.

  PRIVATE SECTION.
    DATA mo_file TYPE REF TO cl_xco_xlsx_file.
    DATA mv_sheet TYPE i.
    DATA ms_bounds TYPE cl_xco_xlsx_slc_pattern=>ty_bounds.

    METHODS new_operation
      IMPORTING
        ir_table            TYPE REF TO data
      RETURNING
        VALUE(ro_operation) TYPE REF TO cl_xco_xlsx_row_operation.
ENDCLASS.

CLASS cl_xco_xlsx_selection IMPLEMENTATION.
  METHOD constructor.
    mo_file = io_file.
    mv_sheet = iv_sheet.
    ms_bounds = is_bounds.
    if_xco_xlsx_ra_row_stream~operation = me.
    if_xco_xlsx_ra_cell_stream~operation = me.
    if_xco_xlsx_wa_row_stream~operation = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_selection~row_stream.
    ro_row_stream = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_selection~cell_stream.
    ro_cell_stream = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_selection~row_stream.
    ro_row_stream = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_rs_operation_fc~write_to.
    ro_operation = new_operation( it_internal_table ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_rs_operation_fc~write_from.
    ro_operation = new_operation( it_internal_table ).
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cs_operation_fc~visit.
    " not implemented, the visitor needs the XCO data processing framework
    RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
  ENDMETHOD.

  METHOD new_operation.
    ro_operation = NEW #( io_file   = mo_file
                          iv_sheet  = mv_sheet
                          is_bounds = ms_bounds
                          ir_table  = ir_table ).
  ENDMETHOD.
ENDCLASS.
