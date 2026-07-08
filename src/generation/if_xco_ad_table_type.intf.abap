INTERFACE if_xco_ad_table_type PUBLIC.
  METHODS exists
    RETURNING VALUE(rv_exists) TYPE abap_bool.

  METHODS content
    RETURNING
      VALUE(ro_content) TYPE REF TO if_xco_ttyp_content.
ENDINTERFACE.
