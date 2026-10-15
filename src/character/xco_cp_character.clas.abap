CLASS xco_cp_character DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-DATA code_page TYPE REF TO if_xco_cp_char_code_page_fctry READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS xco_cp_character IMPLEMENTATION.
  METHOD class_constructor.
    code_page = NEW cl_xco_cp_char_code_page_fctry( ).
  ENDMETHOD.
ENDCLASS.
