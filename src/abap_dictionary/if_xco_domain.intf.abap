INTERFACE if_xco_domain PUBLIC.
  INTERFACES if_xco_ar_object.

  ALIASES exists FOR if_xco_ar_object~exists.
  ALIASES name FOR if_xco_ar_object~name.

  DATA fixed_values TYPE REF TO if_xco_domain_fixed_values READ-ONLY.

  METHODS content
    IMPORTING io_read_state     TYPE REF TO object OPTIONAL
    RETURNING VALUE(ro_content) TYPE REF TO if_xco_domain_content.
  METHODS get_api_state
    RETURNING VALUE(ro_api_state) TYPE REF TO cl_xco_ars_api_state.
ENDINTERFACE.
