CLASS xco_cp_xlsx_selection DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-DATA pattern_builder TYPE REF TO if_xco_cp_xlsx_slc_pb_factory READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS xco_cp_xlsx_selection IMPLEMENTATION.
  METHOD class_constructor.
    pattern_builder = NEW cl_xco_cp_xlsx_slc_pb_factory( ).
  ENDMETHOD.
ENDCLASS.
