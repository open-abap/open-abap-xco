CLASS cl_xco_cp_xlsx_coordinate_fct DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_xlsx.

  PUBLIC SECTION.
    " raises cx_xco_runtime_exception outside of 1 to 1048576, the last row of a worksheet
    METHODS for_numeric_value
      IMPORTING
        iv_numeric_value     TYPE i
      RETURNING
        VALUE(ro_coordinate) TYPE REF TO cl_xco_xlsx_coordinate.

    " raises cx_xco_runtime_exception outside of A to XFD, the last column of a worksheet
    METHODS for_alphabetic_value
      IMPORTING
        iv_alphabetic_value  TYPE clike
      RETURNING
        VALUE(ro_coordinate) TYPE REF TO cl_xco_xlsx_coordinate.
ENDCLASS.

CLASS cl_xco_cp_xlsx_coordinate_fct IMPLEMENTATION.
  METHOD for_numeric_value.
    ro_coordinate = NEW cl_xco_xlsx_coordinate( CONV int8( iv_numeric_value ) ).
  ENDMETHOD.

  METHOD for_alphabetic_value.
    DATA lv_numeric_value TYPE i.

    DATA(lv_letters) = to_upper( condense( CONV string( iv_alphabetic_value ) ) ).
    IF NOT matches( val   = lv_letters
                    regex = `[A-Z]{1,3}` ).
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    DATA(lv_length) = strlen( lv_letters ).
    DO lv_length TIMES.
      DATA(lv_offset) = sy-index - 1.
      lv_numeric_value = lv_numeric_value * 26 + find( val = sy-abcde
                                                       sub = lv_letters+lv_offset(1) ) + 1.
    ENDDO.
    IF lv_numeric_value > cl_xco_xlsx_file=>gc_max_column.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    ro_coordinate = NEW cl_xco_xlsx_coordinate( CONV int8( lv_numeric_value ) ).
  ENDMETHOD.
ENDCLASS.
