INTERFACE if_xco_cds_field PUBLIC.

  DATA name TYPE sxco_cds_field_name READ-ONLY.

  METHODS content
    RETURNING
      VALUE(ro_content) TYPE REF TO if_xco_cds_field_content.

ENDINTERFACE.