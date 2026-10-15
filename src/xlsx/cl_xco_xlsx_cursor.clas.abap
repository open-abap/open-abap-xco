" a cursor on a worksheet, for read and write access
CLASS cl_xco_xlsx_cursor DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_xlsx_worksheet.

  PUBLIC SECTION.
    INTERFACES if_xco_xlsx_ra_cursor.
    INTERFACES if_xco_xlsx_ra_cursor_position.
    INTERFACES if_xco_xlsx_wa_cursor.
    INTERFACES if_xco_xlsx_wa_cursor_position.

    " raises cx_xco_runtime_exception if a coordinate is missing
    METHODS constructor
      IMPORTING
        io_file   TYPE REF TO cl_xco_xlsx_file
        iv_sheet  TYPE i
        io_column TYPE REF TO cl_xco_xlsx_coordinate
        io_row    TYPE REF TO cl_xco_xlsx_coordinate.

  PRIVATE SECTION.
    DATA mo_file TYPE REF TO cl_xco_xlsx_file.
    DATA mv_sheet TYPE i.

    " the one place that changes the position, both position interfaces show it
    METHODS move_to
      IMPORTING
        io_column TYPE REF TO cl_xco_xlsx_coordinate
        io_row    TYPE REF TO cl_xco_xlsx_coordinate.

    METHODS new_cell
      RETURNING
        VALUE(ro_cell) TYPE REF TO cl_xco_xlsx_cell.
ENDCLASS.

CLASS cl_xco_xlsx_cursor IMPLEMENTATION.
  METHOD constructor.
    mo_file = io_file.
    mv_sheet = iv_sheet.
    if_xco_xlsx_ra_cursor~position = me.
    if_xco_xlsx_wa_cursor~position = me.
    move_to( io_column = io_column
             io_row    = io_row ).
  ENDMETHOD.

  METHOD move_to.
    IF io_column IS NOT BOUND OR io_row IS NOT BOUND.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    if_xco_xlsx_ra_cursor_position~column = io_column.
    if_xco_xlsx_ra_cursor_position~row = io_row.
    if_xco_xlsx_wa_cursor_position~column = io_column.
    if_xco_xlsx_wa_cursor_position~row = io_row.
  ENDMETHOD.

  METHOD new_cell.
    ro_cell = NEW #( io_file   = mo_file
                     iv_sheet  = mv_sheet
                     iv_column = if_xco_xlsx_ra_cursor_position~column->get_numeric_value( )
                     iv_row    = if_xco_xlsx_ra_cursor_position~row->get_numeric_value( ) ).
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cursor~has_cell.
    READ TABLE mo_file->mt_cells WITH TABLE KEY sheet  = mv_sheet
                                                row    = if_xco_xlsx_ra_cursor_position~row->get_numeric_value( )
                                                column = if_xco_xlsx_ra_cursor_position~column->get_numeric_value( )
      TRANSPORTING NO FIELDS.
    rv_has_cell = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cursor~get_cell.
    IF if_xco_xlsx_ra_cursor~has_cell( ) = abap_false.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    ro_cell = new_cell( ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_cursor~get_cell.
    ro_cell = new_cell( ).
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cursor~set_column.
    move_to( io_column = io_column
             io_row    = if_xco_xlsx_ra_cursor_position~row ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cursor~set_row.
    move_to( io_column = if_xco_xlsx_ra_cursor_position~column
             io_row    = io_row ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cursor~move_up.
    move_to( io_column = if_xco_xlsx_ra_cursor_position~column
             io_row    = if_xco_xlsx_ra_cursor_position~row->shift( - iv_steps ) ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cursor~move_down.
    move_to( io_column = if_xco_xlsx_ra_cursor_position~column
             io_row    = if_xco_xlsx_ra_cursor_position~row->shift( iv_steps ) ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cursor~move_left.
    move_to( io_column = if_xco_xlsx_ra_cursor_position~column->shift( - iv_steps )
             io_row    = if_xco_xlsx_ra_cursor_position~row ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_cursor~move_right.
    move_to( io_column = if_xco_xlsx_ra_cursor_position~column->shift( iv_steps )
             io_row    = if_xco_xlsx_ra_cursor_position~row ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_cursor~set_column.
    if_xco_xlsx_ra_cursor~set_column( io_column ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_cursor~set_row.
    if_xco_xlsx_ra_cursor~set_row( io_row ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_cursor~move_up.
    if_xco_xlsx_ra_cursor~move_up( iv_steps ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_cursor~move_down.
    if_xco_xlsx_ra_cursor~move_down( iv_steps ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_cursor~move_left.
    if_xco_xlsx_ra_cursor~move_left( iv_steps ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_cursor~move_right.
    if_xco_xlsx_ra_cursor~move_right( iv_steps ).
    ro_me = me.
  ENDMETHOD.
ENDCLASS.
