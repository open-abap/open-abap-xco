CLASS cl_xco_cp_binary_txt_enc_fctry DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_binary.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_binary_txt_enc_fctry.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_binary_txt_enc_fctry IMPLEMENTATION.
  METHOD constructor.
    if_xco_cp_binary_txt_enc_fctry~base64 = NEW lcl_base64( ).
  ENDMETHOD.
ENDCLASS.
