INTERFACE if_xco_cp_ar_ront_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name                   TYPE csequence
    RETURNING VALUE(ro_sap_object_type) TYPE REF TO if_xco_sap_object_type.
ENDINTERFACE.
