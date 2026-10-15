" a worksheet of a file by its position, for read and write access
CLASS cl_xco_xlsx_worksheet DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_xlsx_ra_document cl_xco_xlsx_wa_document.

  PUBLIC SECTION.
    INTERFACES if_xco_xlsx_ra_worksheet.
    INTERFACES if_xco_xlsx_wa_worksheet.

    METHODS constructor
      IMPORTING
        io_file     TYPE REF TO cl_xco_xlsx_file
        iv_position TYPE i.

  PRIVATE SECTION.
    DATA mo_file TYPE REF TO cl_xco_xlsx_file.
    DATA mv_position TYPE i.

    METHODS assert_exists.

    METHODS new_cursor
      IMPORTING
        io_column        TYPE REF TO cl_xco_xlsx_coordinate
        io_row           TYPE REF TO cl_xco_xlsx_coordinate
      RETURNING
        VALUE(ro_cursor) TYPE REF TO cl_xco_xlsx_cursor.

    METHODS new_selection
      IMPORTING
        io_pattern          TYPE REF TO if_xco_xlsx_slc_pattern
      RETURNING
        VALUE(ro_selection) TYPE REF TO cl_xco_xlsx_selection.
ENDCLASS.

CLASS cl_xco_xlsx_worksheet IMPLEMENTATION.
  METHOD constructor.
    mo_file = io_file.
    mv_position = iv_position.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_worksheet~exists.
    rv_exists = xsdbool( mv_position BETWEEN 1 AND mo_file->get_sheet_count( ) ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_worksheet~exists.
    rv_exists = if_xco_xlsx_ra_worksheet~exists( ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_worksheet~set_name.
    assert_exists( ).
    mo_file->set_sheet_name( iv_position = mv_position
                             iv_name     = iv_name ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_worksheet~cursor.
    ro_cursor = new_cursor( io_column = io_column
                            io_row    = io_row ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_worksheet~cursor.
    ro_cursor = new_cursor( io_column = io_column
                            io_row    = io_row ).
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_worksheet~select.
    ro_selection = new_selection( io_pattern ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_worksheet~select.
    ro_selection = new_selection( io_pattern ).
  ENDMETHOD.

  METHOD new_cursor.
    assert_exists( ).
    ro_cursor = NEW #( io_file   = mo_file
                       iv_sheet  = mv_position
                       io_column = io_column
                       io_row    = io_row ).
  ENDMETHOD.

  METHOD new_selection.
    assert_exists( ).
    IF io_pattern IS NOT BOUND.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    DATA(lo_pattern) = CAST cl_xco_xlsx_slc_pattern( io_pattern->get_implementation( ) ).
    ro_selection = NEW #( io_file   = mo_file
                          iv_sheet  = mv_position
                          is_bounds = lo_pattern->get_bounds( ) ).
  ENDMETHOD.

  METHOD assert_exists.
    IF if_xco_xlsx_ra_worksheet~exists( ) = abap_false.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
