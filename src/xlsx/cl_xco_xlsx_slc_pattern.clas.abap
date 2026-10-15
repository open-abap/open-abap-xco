" simple from-to pattern and its builder, unbounded sides are initial
CLASS cl_xco_xlsx_slc_pattern DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_cp_xlsx_slc_pb_factory.
  PUBLIC SECTION.
    INTERFACES if_xco_xlsx_slc_pb_spl_from_to.
    INTERFACES if_xco_xlsx_slc_pattern.

    TYPES:
      BEGIN OF ty_bounds,
        from_column TYPE i,
        to_column   TYPE i,
        from_row    TYPE i,
        to_row      TYPE i,
      END OF ty_bounds.

    CONSTANTS gc_unbounded TYPE i VALUE 2147483647.

    " the selected rectangle, missing upper bounds are gc_unbounded
    METHODS get_bounds
      RETURNING
        VALUE(rs_bounds) TYPE ty_bounds.

  PRIVATE SECTION.
    DATA mo_from_column TYPE REF TO cl_xco_xlsx_coordinate.
    DATA mo_to_column TYPE REF TO cl_xco_xlsx_coordinate.
    DATA mo_from_row TYPE REF TO cl_xco_xlsx_coordinate.
    DATA mo_to_row TYPE REF TO cl_xco_xlsx_coordinate.

    CLASS-METHODS value_of
      IMPORTING
        io_coordinate   TYPE REF TO cl_xco_xlsx_coordinate
        iv_default      TYPE i
      RETURNING
        VALUE(rv_value) TYPE i.
ENDCLASS.

CLASS cl_xco_xlsx_slc_pattern IMPLEMENTATION.
  METHOD if_xco_xlsx_slc_pb_spl_from_to~from_column.
    mo_from_column = io_column.
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_slc_pb_spl_from_to~to_column.
    mo_to_column = io_column.
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_slc_pb_spl_from_to~from_row.
    mo_from_row = io_row.
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_slc_pb_spl_from_to~to_row.
    mo_to_row = io_row.
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_slc_pattern_bldr~get_pattern.
    " a copy, so that further builder calls leave the pattern unchanged
    DATA(lo_pattern) = NEW cl_xco_xlsx_slc_pattern( ).
    lo_pattern->mo_from_column = mo_from_column.
    lo_pattern->mo_to_column = mo_to_column.
    lo_pattern->mo_from_row = mo_from_row.
    lo_pattern->mo_to_row = mo_to_row.

    DATA(ls_bounds) = lo_pattern->get_bounds( ).
    IF ls_bounds-from_column > ls_bounds-to_column OR ls_bounds-from_row > ls_bounds-to_row.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    ro_pattern = lo_pattern.
  ENDMETHOD.

  METHOD if_xco_xlsx_slc_pattern~get_implementation.
    ro_implementation = me.
  ENDMETHOD.

  METHOD get_bounds.
    rs_bounds-from_column = value_of( io_coordinate = mo_from_column
                                      iv_default    = 1 ).
    rs_bounds-to_column = value_of( io_coordinate = mo_to_column
                                    iv_default    = gc_unbounded ).
    rs_bounds-from_row = value_of( io_coordinate = mo_from_row
                                   iv_default    = 1 ).
    rs_bounds-to_row = value_of( io_coordinate = mo_to_row
                                 iv_default    = gc_unbounded ).
  ENDMETHOD.

  METHOD value_of.
    IF io_coordinate IS BOUND.
      rv_value = io_coordinate->get_numeric_value( ).
    ELSE.
      rv_value = iv_default.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
