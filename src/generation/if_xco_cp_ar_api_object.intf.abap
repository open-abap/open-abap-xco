INTERFACE if_xco_cp_ar_api_object PUBLIC.
  DATA devc TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.
  DATA tabl TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.
  DATA clas TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.
  DATA ddls TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.
  DATA ddlx TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.
  DATA bdef TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.
  DATA srvd TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.
  DATA srvb TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.

  METHODS for
    IMPORTING
      iv_type          TYPE csequence OPTIONAL
      iv_name          TYPE csequence OPTIONAL
    RETURNING
      VALUE(ro_object) TYPE REF TO if_xco_ar_objects.
ENDINTERFACE.
