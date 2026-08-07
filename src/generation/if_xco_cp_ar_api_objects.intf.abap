INTERFACE if_xco_cp_ar_api_objects PUBLIC.
  DATA devc TYPE REF TO if_xco_cp_ar_devc_oc_factory READ-ONLY.
  DATA tabl TYPE REF TO if_xco_cp_ar_tabl_object_list READ-ONLY.
  DATA ddls TYPE REF TO if_xco_cp_ar_api_object_list READ-ONLY.
  DATA clas TYPE REF TO if_xco_cp_ar_clas_oc_factory READ-ONLY.
ENDINTERFACE.
