INTERFACE if_xco_cds_entity PUBLIC.

  INTERFACES:
    if_xco_ar_object,
    if_xco_cds_ann_target,
    if_xco_printable.

  DATA fields      TYPE REF TO if_xco_cds_fields_factory READ-ONLY.
  DATA data_source TYPE REF TO if_xco_gen_ddls_s_fo_view_ds READ-ONLY.

  METHODS add_annotation
    IMPORTING iv_name              TYPE csequence
    RETURNING VALUE(ro_annotation) TYPE REF TO if_xco_gen_cds_s_fo_annotation.

  METHODS add_association
    IMPORTING iv_name               TYPE csequence
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_ddls_s_fo_assoc.

  METHODS add_field
    IMPORTING io_field        TYPE REF TO if_xco_gen_ddls_ddl_expression
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.

  METHODS set_root
    RETURNING VALUE(ro_entity) TYPE REF TO if_xco_cds_entity.

  METHODS get_api_state
    IMPORTING
      io_release_contract TYPE REF TO cl_xco_ars_release_contract
    RETURNING
      VALUE(ro_api_state) TYPE REF TO cl_xco_ars_api_state.

ENDINTERFACE.
