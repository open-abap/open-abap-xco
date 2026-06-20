INTERFACE if_xco_gen_ddls_s_fo_p_view PUBLIC.
  INTERFACES if_xco_cds_entity.
  INTERFACES if_xco_gen_cds_s_fo_ann_target.

  ALIASES data_source FOR if_xco_cds_entity~data_source.
  ALIASES add_field FOR if_xco_cds_entity~add_field.
  ALIASES add_annotation FOR if_xco_gen_cds_s_fo_ann_target~add_annotation.
  ALIASES set_root FOR if_xco_cds_entity~set_root.

  METHODS set_provider_contract
    IMPORTING io_provider_contract TYPE REF TO object
    RETURNING VALUE(ro_view)       TYPE REF TO if_xco_gen_ddls_s_fo_p_view.
  METHODS set_where
    IMPORTING io_condition   TYPE REF TO if_xco_gen_ddls_ddl_expression
    RETURNING VALUE(ro_view) TYPE REF TO if_xco_gen_ddls_s_fo_p_view.
ENDINTERFACE.
