INTERFACE if_xco_cds_association PUBLIC.

  DATA name   TYPE sxco_cds_association_name READ-ONLY.
  DATA entity TYPE REF TO if_xco_cds_entity READ-ONLY.

  METHODS content
    RETURNING VALUE(ro_content) TYPE REF TO if_xco_cds_assoc_content.
ENDINTERFACE.
