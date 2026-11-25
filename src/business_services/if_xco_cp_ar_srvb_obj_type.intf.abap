INTERFACE if_xco_cp_ar_srvb_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name                   TYPE csequence
    RETURNING VALUE(ro_service_binding) TYPE REF TO if_xco_service_binding.
ENDINTERFACE.
