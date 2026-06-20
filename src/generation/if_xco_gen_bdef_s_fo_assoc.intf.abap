INTERFACE if_xco_gen_bdef_s_fo_assoc PUBLIC.
  METHODS set_draft_enabled
    IMPORTING iv_enabled            TYPE abap_bool
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_bdef_s_fo_assoc.
  METHODS set_create_enabled
    IMPORTING iv_enabled            TYPE abap_bool OPTIONAL
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_bdef_s_fo_assoc.
  METHODS set_use
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_bdef_s_fo_assoc.
  METHODS set_cardinality
    IMPORTING io_cardinality        TYPE REF TO object
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_bdef_s_fo_assoc.
  METHODS set_condition
    IMPORTING io_condition          TYPE REF TO if_xco_gen_ddls_ddl_expression
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_bdef_s_fo_assoc.
  METHODS set_to_parent
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_bdef_s_fo_assoc.
ENDINTERFACE.
