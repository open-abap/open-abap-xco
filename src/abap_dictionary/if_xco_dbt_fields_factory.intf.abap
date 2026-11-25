INTERFACE if_xco_dbt_fields_factory PUBLIC.
  DATA all TYPE REF TO if_xco_dbt_fields READ-ONLY.
  DATA key TYPE REF TO if_xco_dbt_fields READ-ONLY.

  METHODS get
    RETURNING
      VALUE(rt_fields) TYPE sxco_t_database_table_fields.
ENDINTERFACE.
