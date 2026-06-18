INTERFACE if_xco_cp_cds_assoc_form PUBLIC.
  METHODS set_cardinality
    IMPORTING io_cardinality        TYPE REF TO object
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_cp_cds_assoc_form.
  METHODS set_alias IMPORTING iv_alias TYPE csequence RETURNING VALUE(ro_association) TYPE REF TO if_xco_cp_cds_assoc_form.
  METHODS set_condition
    IMPORTING io_condition          TYPE REF TO if_xco_ddl_field
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_cp_cds_assoc_form.
ENDINTERFACE.
