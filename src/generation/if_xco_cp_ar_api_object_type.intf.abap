INTERFACE if_xco_cp_ar_api_object_type PUBLIC.
  DATA database_table TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.
  DATA structure TYPE REF TO if_xco_cp_ar_api_object_type READ-ONLY.

  METHODS for
    IMPORTING iv_name          TYPE csequence
    RETURNING VALUE(ro_object) TYPE REF TO if_xco_ar_objects.
ENDINTERFACE.
