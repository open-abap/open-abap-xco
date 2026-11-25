INTERFACE if_xco_ad_field_type PUBLIC.
  METHODS is_data_element RETURNING VALUE(rv_result) TYPE abap_bool.
  METHODS is_built_in_type RETURNING VALUE(rv_result) TYPE abap_bool.
  METHODS get_data_element RETURNING VALUE(ro_data_element) TYPE REF TO if_xco_ad_data_element.
  METHODS get_built_in_type RETURNING VALUE(ro_built_in_type) TYPE REF TO cl_xco_ad_built_in_type.
ENDINTERFACE.
