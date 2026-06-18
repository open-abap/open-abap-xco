INTERFACE if_xco_cp_gen_ddls_s_form PUBLIC.
  METHODS set_short_description
    IMPORTING iv_short_description TYPE csequence
    RETURNING VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_ddls_s_form.
  METHODS add_custom_entity
    RETURNING VALUE(ro_entity) TYPE REF TO if_xco_cp_cds_entity_form.
  METHODS add_abstract_entity
    RETURNING VALUE(ro_entity) TYPE REF TO if_xco_cp_cds_entity_form.
  METHODS add_view_entity
    RETURNING VALUE(ro_entity) TYPE REF TO if_xco_cp_cds_entity_form.
  METHODS add_projection_view
    RETURNING VALUE(ro_entity) TYPE REF TO if_xco_cp_cds_entity_form.
  METHODS add_exposure
    IMPORTING iv_name           TYPE csequence
    RETURNING VALUE(ro_service) TYPE REF TO if_xco_cp_service_form.
  METHODS set_binding_type
    IMPORTING iv_binding_type TYPE csequence
    RETURNING VALUE(ro_form)  TYPE REF TO if_xco_cp_gen_ddls_s_form.
  METHODS add_service
    RETURNING VALUE(ro_service) TYPE REF TO if_xco_cp_service_form.
ENDINTERFACE.
