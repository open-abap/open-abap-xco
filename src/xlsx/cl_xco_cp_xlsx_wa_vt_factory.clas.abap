CLASS cl_xco_cp_xlsx_wa_vt_factory DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_xlsx_write_access.

  PUBLIC SECTION.
    DATA best_effort TYPE REF TO if_xco_xlsx_wa_vt_best_effort READ-ONLY.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_xlsx_wa_vt_factory IMPLEMENTATION.
  METHOD constructor.
    best_effort = NEW cl_xco_xlsx_value_trnsfrmtn( cl_xco_xlsx_value_trnsfrmtn=>gc_kind-best_effort ).
  ENDMETHOD.
ENDCLASS.
