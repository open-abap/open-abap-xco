INTERFACE if_xco_ddl_expression_factory PUBLIC.
  METHODS for
    IMPORTING
      iv_expression        TYPE csequence
    RETURNING
      VALUE(ro_expression) TYPE REF TO if_xco_ddl_expr_condition.
ENDINTERFACE.
