INTERFACE if_xco_gen_ddls_template PUBLIC.
  METHODS set_short_description
    IMPORTING iv_short_description TYPE csequence
    RETURNING VALUE(ro_form)       TYPE REF TO if_xco_gen_ddls_template.
  METHODS add_custom_entity
    RETURNING VALUE(ro_entity) TYPE REF TO if_xco_cds_entity.
  METHODS add_abstract_entity
    RETURNING VALUE(ro_entity) TYPE REF TO if_xco_cds_entity.
  METHODS add_view_entity
    RETURNING VALUE(ro_entity) TYPE REF TO if_xco_cds_entity.
  METHODS add_projection_view
    RETURNING VALUE(ro_entity) TYPE REF TO if_xco_cds_entity.
  METHODS add_exposure
    IMPORTING iv_name           TYPE csequence
    RETURNING VALUE(ro_service) TYPE REF TO if_xco_gen_srvb_s_fo_service.
  METHODS set_binding_type
    IMPORTING iv_binding_type TYPE csequence
    RETURNING VALUE(ro_form)  TYPE REF TO if_xco_gen_ddls_template.
  METHODS add_service
    RETURNING VALUE(ro_service) TYPE REF TO if_xco_gen_srvb_s_fo_service.
ENDINTERFACE.
