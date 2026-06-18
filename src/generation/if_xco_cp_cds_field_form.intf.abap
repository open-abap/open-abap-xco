INTERFACE if_xco_cp_cds_field_form PUBLIC.
  METHODS set_key RETURNING VALUE(ro_field) TYPE REF TO if_xco_cp_cds_field_form.
  METHODS set_alias IMPORTING iv_alias TYPE csequence RETURNING VALUE(ro_field) TYPE REF TO if_xco_cp_cds_field_form.
  METHODS set_type IMPORTING io_type TYPE REF TO if_xco_ad_type RETURNING VALUE(ro_field) TYPE REF TO if_xco_cp_cds_field_form.
  METHODS add_annotation IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_annotation) TYPE REF TO if_xco_cp_cds_annotation.
ENDINTERFACE.
