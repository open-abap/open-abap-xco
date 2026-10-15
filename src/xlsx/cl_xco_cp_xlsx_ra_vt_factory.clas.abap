CLASS cl_xco_cp_xlsx_ra_vt_factory DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_xlsx_read_access.

  PUBLIC SECTION.
    DATA identity TYPE REF TO if_xco_xlsx_ra_vt_identity READ-ONLY.
    DATA string_value TYPE REF TO if_xco_xlsx_ra_vt_string_value READ-ONLY.
    DATA best_effort TYPE REF TO if_xco_xlsx_ra_vt_best_effort READ-ONLY.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_xlsx_ra_vt_factory IMPLEMENTATION.
  METHOD constructor.
    identity = NEW cl_xco_xlsx_value_trnsfrmtn( cl_xco_xlsx_value_trnsfrmtn=>gc_kind-identity ).
    string_value = NEW cl_xco_xlsx_value_trnsfrmtn( cl_xco_xlsx_value_trnsfrmtn=>gc_kind-string_value ).
    best_effort = NEW cl_xco_xlsx_value_trnsfrmtn( cl_xco_xlsx_value_trnsfrmtn=>gc_kind-best_effort ).
  ENDMETHOD.
ENDCLASS.
