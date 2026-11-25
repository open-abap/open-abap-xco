CLASS xco_cp_bal DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-DATA:
      level_of_detail TYPE REF TO cl_xco_cp_bal_lvl_of_dtl_f READ-ONLY,
      profile TYPE REF TO if_xco_cp_bal_profile_factory READ-ONLY,
      for     TYPE REF TO if_xco_cp_bal_source_factory READ-ONLY.
ENDCLASS.

CLASS xco_cp_bal IMPLEMENTATION.
ENDCLASS.
