INTERFACE if_xco_cp_ar_dbt_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name         TYPE csequence
    RETURNING VALUE(ro_table) TYPE REF TO if_xco_database_table.
ENDINTERFACE.
