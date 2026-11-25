CLASS lcl_format DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_uuid_format.

    CONSTANTS:
      BEGIN OF c_length,
        c22 TYPE i VALUE 22,
        c32 TYPE i VALUE 32,
        c36 TYPE i VALUE 36,
      END OF c_length.

    METHODS constructor
      IMPORTING
        iv_length TYPE i.

  PRIVATE SECTION.
    DATA mv_length TYPE i.
ENDCLASS.

CLASS lcl_format IMPLEMENTATION.
  METHOD constructor.
    mv_length = iv_length.
  ENDMETHOD.

  METHOD if_xco_uuid_format~from_uuid.
    DATA lv_c22 TYPE sysuuid_c22.
    DATA lv_c32 TYPE sysuuid_c32.
    DATA lv_c36 TYPE sysuuid_c36.

    TRY.
        cl_system_uuid=>convert_uuid_x16_static(
          EXPORTING
            uuid     = io_uuid->value
          IMPORTING
            uuid_c22 = lv_c22
            uuid_c32 = lv_c32
            uuid_c36 = lv_c36 ).
      CATCH cx_uuid_error INTO DATA(lx_uuid_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_uuid_error ).
    ENDTRY.

    CASE mv_length.
      WHEN c_length-c22.
        rv_string = lv_c22.
      WHEN c_length-c32.
        rv_string = lv_c32.
      WHEN OTHERS.
        rv_string = lv_c36.
    ENDCASE.
  ENDMETHOD.

  METHOD if_xco_uuid_format~to_uuid.
    DATA lv_x16 TYPE sysuuid_x16.

    " checked here, as the conversion to the fixed length type below would truncate longer input
    IF strlen( iv_string ) <> mv_length.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    TRY.
        CASE mv_length.
          WHEN c_length-c22.
            cl_system_uuid=>convert_uuid_c22_static(
              EXPORTING
                uuid     = CONV #( iv_string )
              IMPORTING
                uuid_x16 = lv_x16 ).
          WHEN c_length-c32.
            cl_system_uuid=>convert_uuid_c32_static(
              EXPORTING
                uuid     = CONV #( iv_string )
              IMPORTING
                uuid_x16 = lv_x16 ).
          WHEN OTHERS.
            cl_system_uuid=>convert_uuid_c36_static(
              EXPORTING
                uuid     = CONV #( iv_string )
              IMPORTING
                uuid_x16 = lv_x16 ).
        ENDCASE.
      CATCH cx_uuid_error INTO DATA(lx_uuid_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_uuid_error ).
    ENDTRY.

    ro_uuid = xco_cp=>uuid( lv_x16 ).
  ENDMETHOD.
ENDCLASS.
