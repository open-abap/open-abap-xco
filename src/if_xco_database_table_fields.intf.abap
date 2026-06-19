INTERFACE if_xco_database_table_fields PUBLIC.
  DATA all TYPE REF TO if_xco_database_table_fields READ-ONLY.

  METHODS get
    RETURNING
      VALUE(rt_fields) TYPE sxco_t_database_table_fields.
ENDINTERFACE.
