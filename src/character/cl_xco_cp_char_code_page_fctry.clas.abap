CLASS cl_xco_cp_char_code_page_fctry DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_character.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_char_code_page_fctry.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_char_code_page_fctry IMPLEMENTATION.
  METHOD constructor.
    if_xco_cp_char_code_page_fctry~utf_8 = if_xco_cp_char_code_page_fctry~for( `UTF-8` ).
  ENDMETHOD.

  METHOD if_xco_cp_char_code_page_fctry~for.
    ro_code_page = NEW lcl_code_page( iv_value ).
  ENDMETHOD.
ENDCLASS.
