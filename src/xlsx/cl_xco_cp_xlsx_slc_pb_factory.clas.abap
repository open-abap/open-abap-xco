CLASS cl_xco_cp_xlsx_slc_pb_factory DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_xlsx_selection.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_xlsx_slc_pb_factory.
ENDCLASS.

CLASS cl_xco_cp_xlsx_slc_pb_factory IMPLEMENTATION.
  METHOD if_xco_cp_xlsx_slc_pb_factory~simple_from_to.
    ro_simple_from_to = NEW cl_xco_xlsx_slc_pattern( ).
  ENDMETHOD.
ENDCLASS.
