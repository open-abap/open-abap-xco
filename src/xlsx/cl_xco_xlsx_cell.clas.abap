" a cell of a worksheet, for read and write access
CLASS cl_xco_xlsx_cell DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_xlsx_cursor.

  PUBLIC SECTION.
    INTERFACES if_xco_xlsx_ra_cell.
    INTERFACES if_xco_xlsx_ra_cell_value.
    INTERFACES if_xco_xlsx_wa_cell.
    INTERFACES if_xco_xlsx_wa_cell_value.

    METHODS constructor
      IMPORTING
        io_file   TYPE REF TO cl_xco_xlsx_file
        iv_sheet  TYPE i
        iv_column TYPE i
        iv_row    TYPE i.

  PRIVATE SECTION.
    DATA mo_file TYPE REF TO cl_xco_xlsx_file.
    DATA ms_position TYPE cl_xco_xlsx_file=>ty_cell.
    DATA mo_transformation TYPE REF TO cl_xco_xlsx_value_trnsfrmtn.

    " the cell in the file, without type if it does not exist
    METHODS stored_cell
      RETURNING
        VALUE(rs_cell) TYPE cl_xco_xlsx_file=>ty_cell.
ENDCLASS.

CLASS cl_xco_xlsx_cell IMPLEMENTATION.
  METHOD constructor.
    mo_file = io_file.
    ms_position = VALUE #( sheet  = iv_sheet
                           row    = iv_row
                           column = iv_column ).
    " best effort is the default of read and write access
    mo_transformation ?= xco_cp_xlsx_read_access=>value_transformation->best_effort->if_xco_xlsx_ra_vt_cell_value~get_implementation( ).
    if_xco_xlsx_wa_cell~value = me.
  ENDMETHOD.

  METHOD stored_cell.
    READ TABLE mo_file->mt_cells WITH TABLE KEY sheet  = ms_position-sheet
                                                row    = ms_position-row
                                                column = ms_position-column INTO rs_cell.
    IF sy-subrc <> 0.
      CLEAR rs_cell.
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cell~has_value.
    rv_has_value = xsdbool( stored_cell( )-type IS NOT INITIAL ).
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cell~get_value.
    ro_value = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cell_value~set_transformation.
    mo_transformation ?= io_transformation->get_implementation( ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cell_value~write_to.
    FIELD-SYMBOLS <lv_field> TYPE any.

    IF iv_field IS NOT BOUND.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    ASSIGN iv_field->* TO <lv_field>.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    mo_transformation->read( EXPORTING is_cell  = stored_cell( )
                             CHANGING  cv_field = <lv_field> ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_cell_value~set_transformation.
    mo_transformation ?= io_transformation->get_implementation( ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_cell_value~write_from.
    DATA(ls_cell) = mo_transformation->write( iv_field ).
    ls_cell-sheet = ms_position-sheet.
    ls_cell-row = ms_position-row.
    ls_cell-column = ms_position-column.
    mo_file->set_cell( ls_cell ).
  ENDMETHOD.
ENDCLASS.
