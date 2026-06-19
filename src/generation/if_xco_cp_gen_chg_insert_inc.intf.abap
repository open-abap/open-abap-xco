INTERFACE if_xco_cp_gen_chg_insert_inc PUBLIC.
  METHODS set_structure
    IMPORTING iv_structure_name TYPE csequence
    RETURNING VALUE(ro_include) TYPE REF TO if_xco_cp_gen_chg_insert_inc.
ENDINTERFACE.
