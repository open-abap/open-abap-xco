INTERFACE if_xco_cp_ar_api_object PUBLIC.
  DATA devc TYPE REF TO if_xco_cp_ar_devc_obj_type READ-ONLY.
  DATA tabl TYPE REF TO if_xco_cp_ar_tabl_obj_type READ-ONLY.
  DATA clas TYPE REF TO if_xco_cp_ar_clas_obj_type READ-ONLY.
  DATA ddls TYPE REF TO if_xco_cp_ar_ddls_obj_type READ-ONLY.
  DATA ddlx TYPE REF TO if_xco_cp_ar_ddlx_obj_type READ-ONLY.
  DATA bdef TYPE REF TO if_xco_cp_ar_bdef_obj_type READ-ONLY.
  DATA srvd TYPE REF TO if_xco_cp_ar_srvd_obj_type READ-ONLY.
  DATA srvb TYPE REF TO if_xco_cp_ar_srvb_obj_type READ-ONLY.
  DATA dtel TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.
  DATA nont TYPE REF TO if_xco_cp_ar_nont_obj_type READ-ONLY.
  DATA ront TYPE REF TO if_xco_cp_ar_ront_obj_type READ-ONLY.

  METHODS for
    IMPORTING
      iv_type          TYPE csequence OPTIONAL
      iv_name          TYPE csequence OPTIONAL
    RETURNING
      VALUE(ro_object) TYPE REF TO if_xco_ar_objects.
ENDINTERFACE.
