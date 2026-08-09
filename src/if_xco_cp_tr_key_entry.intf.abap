INTERFACE if_xco_cp_tr_key_entry PUBLIC.
  METHODS get_table_key
    RETURNING
      VALUE(ro_table_key) TYPE REF TO if_xco_cp_tr_ke_table_key.
ENDINTERFACE.