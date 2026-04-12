INTERFACE if_xco_cds_entity PUBLIC.

  INTERFACES:
    if_xco_ar_object,
    if_xco_cds_ann_target,
    if_xco_printable.

  DATA fields TYPE REF TO if_xco_cds_fields_factory READ-ONLY.

ENDINTERFACE.