CLASS xco_cp_binary DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-DATA text_encoding TYPE REF TO if_xco_cp_binary_txt_enc_fctry READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS xco_cp_binary IMPLEMENTATION.
  METHOD class_constructor.
    text_encoding = NEW cl_xco_cp_binary_txt_enc_fctry( ).
  ENDMETHOD.
ENDCLASS.
