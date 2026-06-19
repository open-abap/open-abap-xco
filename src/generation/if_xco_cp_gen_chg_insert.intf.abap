INTERFACE if_xco_cp_gen_chg_insert PUBLIC.
  METHODS add_include
    RETURNING VALUE(ro_include) TYPE REF TO if_xco_cp_gen_chg_insert_inc.
ENDINTERFACE.
