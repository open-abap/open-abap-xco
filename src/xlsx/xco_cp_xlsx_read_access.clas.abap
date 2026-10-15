CLASS xco_cp_xlsx_read_access DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-DATA value_transformation TYPE REF TO cl_xco_cp_xlsx_ra_vt_factory READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS xco_cp_xlsx_read_access IMPLEMENTATION.
  METHOD class_constructor.
    value_transformation = NEW cl_xco_cp_xlsx_ra_vt_factory( ).
  ENDMETHOD.
ENDCLASS.
