INTERFACE if_xco_gen_ddls_s_fo_assoc PUBLIC.
  METHODS set_cardinality
    IMPORTING io_cardinality        TYPE REF TO object
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_ddls_s_fo_assoc.
  METHODS set_alias IMPORTING iv_alias TYPE csequence RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_ddls_s_fo_assoc.
  METHODS set_condition
    IMPORTING io_condition          TYPE REF TO if_xco_gen_ddls_ddl_expression
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_ddls_s_fo_assoc.
ENDINTERFACE.
