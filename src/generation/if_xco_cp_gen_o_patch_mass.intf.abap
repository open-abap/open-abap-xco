INTERFACE if_xco_cp_gen_o_patch_mass PUBLIC.
  TYPES: BEGIN OF ts_tabl_for,
           database_table TYPE REF TO if_xco_cp_gen_patch_sct,
         END OF ts_tabl_for.
  TYPES: BEGIN OF ts_tabl,
           for TYPE ts_tabl_for,
         END OF ts_tabl.
  TYPES: BEGIN OF ts_for,
           tabl TYPE ts_tabl,
         END OF ts_for.

  DATA for TYPE ts_for READ-ONLY.

  METHODS execute
    RETURNING VALUE(ro_result) TYPE REF TO if_xco_gen_o_put_result.
ENDINTERFACE.
