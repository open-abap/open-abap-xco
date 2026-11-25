INTERFACE if_xco_cds_annotation PUBLIC.
  METHODS get_value
    RETURNING VALUE(ro_value) TYPE REF TO if_xco_cds_annotation_value.
ENDINTERFACE.
