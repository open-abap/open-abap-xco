INTERFACE if_xco_cp_gen_change_spec PUBLIC.
  TYPES: BEGIN OF ts_for,
           insert TYPE REF TO if_xco_cp_gen_chg_insert,
         END OF ts_for.

  DATA for TYPE ts_for READ-ONLY.
ENDINTERFACE.
