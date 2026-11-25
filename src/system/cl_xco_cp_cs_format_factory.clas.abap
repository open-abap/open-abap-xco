CLASS cl_xco_cp_cs_format_factory DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_cs_format_factory.
ENDCLASS.

CLASS cl_xco_cp_cs_format_factory IMPLEMENTATION.
  METHOD if_xco_cp_cs_format_factory~adt.
    ro_adt = NEW #( ).
  ENDMETHOD.
ENDCLASS.
