INTERFACE if_xco_cp_ar_srvd_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name                      TYPE csequence
    RETURNING VALUE(ro_service_definition) TYPE REF TO if_xco_service_definition.
ENDINTERFACE.
