INTERFACE if_xco_cds_composition PUBLIC.
  DATA target TYPE REF TO if_xco_cds_view READ-ONLY.
  DATA composition TYPE REF TO if_xco_cds_composition_ct READ-ONLY.

  METHODS content
    RETURNING VALUE(ro_content) TYPE REF TO if_xco_cds_composition_ct.
ENDINTERFACE.
