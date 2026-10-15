CLASS lcl_base64 DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_binary_text_encoding.

  PRIVATE SECTION.
    " complete groups of four characters, only the last group may end with one or two "="
    CONSTANTS c_pattern TYPE string VALUE `(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?`.
ENDCLASS.

CLASS lcl_base64 IMPLEMENTATION.
  METHOD if_xco_xstring_string_cnvrsn~apply.
    rv_string = cl_web_http_utility=>encode_x_base64( iv_xstring ).
  ENDMETHOD.

  METHOD if_xco_string_xstring_cnvrsn~apply.
    " the decoder skips characters outside the alphabet, so the input is checked first
    IF NOT matches( val  = iv_string
                    pcre = c_pattern ).
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    rv_xstring = cl_web_http_utility=>decode_x_base64( iv_string ).
  ENDMETHOD.
ENDCLASS.
