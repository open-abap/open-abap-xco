INTERFACE if_xco_cds_field_content PUBLIC.

  METHODS get_key_indicator
    RETURNING
      VALUE(rv_key_indicator) TYPE abap_bool.

ENDINTERFACE.