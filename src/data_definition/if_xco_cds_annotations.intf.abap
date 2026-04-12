INTERFACE if_xco_cds_annotations PUBLIC.

  METHODS contain
    IMPORTING
      iv_property       TYPE sxco_cds_ann_property
    RETURNING
      VALUE(rv_contain) TYPE abap_bool.

ENDINTERFACE.