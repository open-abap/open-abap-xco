INTERFACE if_xco_cp_ar_tabl_obj_type PUBLIC.
  DATA database_table TYPE REF TO if_xco_cp_ar_dbt_obj_type READ-ONLY.
  DATA structure      TYPE REF TO if_xco_cp_ar_struc_obj_type READ-ONLY.

  METHODS for
    IMPORTING iv_name         TYPE csequence
    RETURNING VALUE(ro_table) TYPE REF TO if_xco_database_table.
ENDINTERFACE.
