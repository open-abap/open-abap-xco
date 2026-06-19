INTERFACE if_xco_ad_structure_component PUBLIC.
  DATA name TYPE sxco_ad_field_name READ-ONLY.

  METHODS content
    RETURNING
      VALUE(ro_content) TYPE REF TO if_xco_ad_structure_comp_ct.
ENDINTERFACE.
