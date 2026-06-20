INTERFACE if_xco_dtel_data_type PUBLIC.
  METHODS is_domain
    RETURNING VALUE(rv_result) TYPE abap_bool.
  METHODS is_built_in_type
    RETURNING VALUE(rv_result) TYPE abap_bool.
  METHODS get_domain
    RETURNING VALUE(ro_domain) TYPE REF TO if_xco_domain.
  METHODS get_built_in_type
    RETURNING VALUE(ro_built_in_type) TYPE REF TO cl_xco_ad_built_in_type.
ENDINTERFACE.
