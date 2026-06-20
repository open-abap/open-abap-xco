INTERFACE if_xco_cp_gen_env_dev_system PUBLIC.
  TYPES: BEGIN OF ts_tabl_for,
           database_table TYPE REF TO if_xco_cp_gen_tabl_dbt_dopu_sc,
           structure      TYPE REF TO if_xco_cp_gen_tabl_str_dopu_sc,
         END OF ts_tabl_for.
  TYPES: BEGIN OF ts_tabl,
           for TYPE ts_tabl_for,
         END OF ts_tabl.
  TYPES: BEGIN OF ts_for,
           devc TYPE REF TO if_xco_cp_gen_devc_d_api,
           tabl TYPE ts_tabl,
           ddls TYPE REF TO if_xco_cp_gen_ddls_d_api,
           ddlx TYPE REF TO if_xco_cp_gen_ddlx_d_api,
           bdef TYPE REF TO if_xco_cp_gen_bdef_d_api,
           clas TYPE REF TO if_xco_cp_gen_clas_d_api,
           srvd TYPE REF TO if_xco_cp_gen_srvd_d_api,
           srvb TYPE REF TO if_xco_cp_gen_srvb_d_api,
           dcls TYPE REF TO if_xco_cp_gen_dcls_d_api,
           intf TYPE REF TO if_xco_cp_gen_intf_d_api,
         END OF ts_for.

  DATA for TYPE ts_for READ-ONLY.

  METHODS create_put_operation
    RETURNING
      VALUE(ro_put_operation) TYPE REF TO if_xco_cp_gen_d_o_put.

  METHODS create_patch_operation
    RETURNING
      VALUE(ro_patch_operation) TYPE REF TO if_xco_cp_gen_o_patch_mass.
ENDINTERFACE.
