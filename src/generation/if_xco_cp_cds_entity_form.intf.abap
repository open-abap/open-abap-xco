INTERFACE if_xco_cp_cds_entity_form PUBLIC.
  DATA data_source TYPE REF TO if_xco_cp_cds_data_source READ-ONLY.

  METHODS set_root RETURNING VALUE(ro_entity) TYPE REF TO if_xco_cp_cds_entity_form.
  METHODS add_annotation
    IMPORTING iv_name              TYPE csequence
    RETURNING VALUE(ro_annotation) TYPE REF TO if_xco_cp_cds_annotation.
  METHODS add_field
    IMPORTING io_field        TYPE REF TO if_xco_ddl_field OPTIONAL
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_cp_cds_field_form.
  METHODS add_association
    IMPORTING iv_name               TYPE csequence
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_cp_cds_assoc_form.
ENDINTERFACE.
