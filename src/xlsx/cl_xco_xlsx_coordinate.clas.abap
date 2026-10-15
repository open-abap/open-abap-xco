CLASS cl_xco_xlsx_coordinate DEFINITION PUBLIC CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_cp_xlsx_coordinate_fct.

  PUBLIC SECTION.
    " SAP declares the class and GET_NUMERIC_VALUE as ABSTRACT, a single
    " implementation is enough here as nobody outside can create or inherit
    METHODS get_numeric_value
      RETURNING
        VALUE(rv_numeric_value) TYPE i.

    METHODS get_alphabetic_value FINAL
      RETURNING
        VALUE(rv_alphabetic_value) TYPE string.

    METHODS shift FINAL
      IMPORTING
        iv_offset            TYPE i
      RETURNING
        VALUE(ro_coordinate) TYPE REF TO cl_xco_xlsx_coordinate.

    " raises cx_xco_runtime_exception outside of 1 to the last row of a worksheet
    METHODS constructor
      IMPORTING
        iv_numeric_value TYPE int8.

  PRIVATE SECTION.
    DATA mv_numeric_value TYPE i.
ENDCLASS.

CLASS cl_xco_xlsx_coordinate IMPLEMENTATION.
  METHOD constructor.
    IF iv_numeric_value < 1 OR iv_numeric_value > cl_xco_xlsx_file=>gc_max_row.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    mv_numeric_value = iv_numeric_value.
  ENDMETHOD.

  METHOD get_numeric_value.
    rv_numeric_value = mv_numeric_value.
  ENDMETHOD.

  METHOD get_alphabetic_value.
    " bijective base 26: A = 1, Z = 26, AA = 27
    DATA(lv_value) = mv_numeric_value.
    WHILE lv_value > 0.
      DATA(lv_letter) = ( lv_value - 1 ) MOD 26.
      rv_alphabetic_value = sy-abcde+lv_letter(1) && rv_alphabetic_value.
      lv_value = ( lv_value - 1 ) DIV 26.
    ENDWHILE.
  ENDMETHOD.

  METHOD shift.
    " in INT8, so that no offset overflows
    ro_coordinate = NEW cl_xco_xlsx_coordinate( CONV int8( mv_numeric_value ) + iv_offset ).
  ENDMETHOD.
ENDCLASS.
