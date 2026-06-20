INTERFACE if_xco_dtel_content PUBLIC.
  TYPES: BEGIN OF ts_data_element,
           data_type TYPE REF TO if_xco_dtel_data_type,
         END OF ts_data_element.

  METHODS get
    RETURNING VALUE(rs_data_element) TYPE ts_data_element.
  METHODS has_underlying_built_in_type
    RETURNING VALUE(rv_result) TYPE abap_bool.
  METHODS get_underlying_built_in_type
    RETURNING VALUE(ro_built_in_type) TYPE REF TO cl_xco_ad_built_in_type.
ENDINTERFACE.
