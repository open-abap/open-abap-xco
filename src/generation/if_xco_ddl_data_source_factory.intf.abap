INTERFACE if_xco_ddl_data_source_factory PUBLIC.
  METHODS database_table
    IMPORTING
      iv_name               TYPE csequence
    RETURNING
      VALUE(ro_data_source) TYPE REF TO if_xco_ddl_expr_data_source.
ENDINTERFACE.
