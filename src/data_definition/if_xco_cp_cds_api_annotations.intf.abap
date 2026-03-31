INTERFACE if_xco_cp_cds_api_annotations PUBLIC.

  DATA metadata_extension TYPE REF TO cl_xco_cds_ann_class READ-ONLY.
  DATA direct             TYPE REF TO cl_xco_cds_ann_class READ-ONLY.
  DATA inherited          TYPE REF TO cl_xco_cds_ann_class READ-ONLY.
  DATA derived            TYPE REF TO cl_xco_cds_ann_class READ-ONLY.
  DATA aggregated         TYPE REF TO cl_xco_cds_ann_class READ-ONLY.

ENDINTERFACE.