INTERFACE if_xco_ad_structure_comp_ct PUBLIC.
  METHODS get_type
    RETURNING
      VALUE(ro_type) TYPE REF TO if_xco_ad_field_type.
ENDINTERFACE.
