INTERFACE if_xco_gen_ddls_s_fo_field PUBLIC.
  METHODS set_key RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
  METHODS set_alias IMPORTING iv_alias TYPE csequence RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
  METHODS set_type
    IMPORTING io_type         TYPE REF TO if_xco_ad_built_in_type_rfrnc
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
  METHODS add_annotation IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_annotation) TYPE REF TO if_xco_gen_cds_s_fo_annotation.
ENDINTERFACE.
