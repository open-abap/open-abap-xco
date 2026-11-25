CLASS cl_xco_cs_line_number_flavor DEFINITION PUBLIC ABSTRACT CREATE PROTECTED.
  PUBLIC SECTION.
    INTERFACES if_xco_cs_line_number_flavor FINAL METHODS get_implementation.
ENDCLASS.

CLASS cl_xco_cs_line_number_flavor IMPLEMENTATION.
  METHOD if_xco_cs_line_number_flavor~get_implementation.
    ro_implementation = me.
  ENDMETHOD.
ENDCLASS.
