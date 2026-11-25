CLASS cl_xco_cs_format DEFINITION PUBLIC ABSTRACT CREATE PROTECTED
  GLOBAL FRIENDS cl_xco_cp_call_stack.

  PUBLIC SECTION.
    INTERFACES if_xco_cs_format FINAL METHODS get_implementation.

  PROTECTED SECTION.
    METHODS format_frame ABSTRACT
      IMPORTING
        is_frame       TYPE cl_xco_cp_call_stack=>ty_frame
      RETURNING
        VALUE(rv_line) TYPE string.
ENDCLASS.

CLASS cl_xco_cs_format IMPLEMENTATION.
  METHOD if_xco_cs_format~get_implementation.
    ro_implementation = me.
  ENDMETHOD.
ENDCLASS.
