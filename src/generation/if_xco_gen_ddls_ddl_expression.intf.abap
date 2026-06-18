INTERFACE if_xco_gen_ddls_ddl_expression PUBLIC.
  METHODS of_projection RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_ddl_expression.
  METHODS of IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_ddl_expression.
  METHODS eq
    IMPORTING io_field        TYPE REF TO if_xco_gen_ddls_ddl_expression
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_ddl_expression.
  METHODS and
    IMPORTING io_field        TYPE REF TO if_xco_gen_ddls_ddl_expression
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_ddl_expression.
ENDINTERFACE.
