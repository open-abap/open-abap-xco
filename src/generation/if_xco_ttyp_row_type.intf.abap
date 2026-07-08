INTERFACE if_xco_ttyp_row_type PUBLIC.
  METHODS get_structure
    RETURNING
      VALUE(ro_structure) TYPE REF TO if_xco_ad_structure.
  METHODS is_structure
    RETURNING
      VALUE(rv_is_structure) TYPE abap_bool.
ENDINTERFACE.