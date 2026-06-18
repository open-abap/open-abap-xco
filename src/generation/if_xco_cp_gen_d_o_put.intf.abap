INTERFACE if_xco_cp_gen_d_o_put PUBLIC.
  TYPES: BEGIN OF ts_tabl_for,
           database_table TYPE REF TO if_xco_cp_gen_tabl_dbt_d_o_put,
         END OF ts_tabl_for.
  TYPES: BEGIN OF ts_tabl,
           for TYPE ts_tabl_for,
         END OF ts_tabl.
  TYPES: BEGIN OF ts_for,
           tabl TYPE ts_tabl,
           ddls TYPE REF TO if_xco_cp_gen_ddls_d_o_put,
           ddlx TYPE REF TO if_xco_cp_gen_ddls_d_o_put,
           bdef TYPE REF TO if_xco_cp_gen_ddls_d_o_put,
           srvd TYPE REF TO if_xco_cp_gen_ddls_d_o_put,
           srvb TYPE REF TO if_xco_cp_gen_ddls_d_o_put,
           clas TYPE REF TO if_xco_cp_gen_clas_d_o_put,
         END OF ts_for.

  DATA for TYPE ts_for READ-ONLY.

  METHODS execute
    RETURNING
      VALUE(ro_result) TYPE REF TO if_xco_gen_o_put_result.
ENDINTERFACE.
