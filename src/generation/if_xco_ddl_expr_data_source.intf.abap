INTERFACE if_xco_ddl_expr_data_source PUBLIC.
  METHODS set_alias
    IMPORTING
      iv_alias              TYPE csequence
    RETURNING
      VALUE(ro_data_source) TYPE REF TO if_xco_ddl_expr_data_source.
ENDINTERFACE.
