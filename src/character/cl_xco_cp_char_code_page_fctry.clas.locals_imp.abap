CLASS lcl_code_page DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_char_code_page.

    METHODS constructor
      IMPORTING
        iv_name TYPE string.

  PRIVATE SECTION.
    DATA mv_name TYPE string.
ENDCLASS.

CLASS lcl_code_page IMPLEMENTATION.
  METHOD constructor.
    mv_name = iv_name.
  ENDMETHOD.

  METHOD if_xco_string_xstring_cnvrsn~apply.
    TRY.
        rv_xstring = cl_abap_conv_codepage=>create_out( mv_name )->convert( iv_string ).
      CATCH cx_parameter_invalid_range cx_sy_conversion_codepage INTO DATA(lx_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_error ).
    ENDTRY.
  ENDMETHOD.

  METHOD if_xco_xstring_string_cnvrsn~apply.
    TRY.
        rv_string = cl_abap_conv_codepage=>create_in( mv_name )->convert( iv_xstring ).
      CATCH cx_parameter_invalid_range cx_sy_conversion_codepage INTO DATA(lx_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_error ).
    ENDTRY.
  ENDMETHOD.

  METHOD if_xco_printable~get_text.
    ro_text = xco_cp=>string( mv_name ).
  ENDMETHOD.
ENDCLASS.
