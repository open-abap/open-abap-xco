INTERFACE if_xco_srvb_lcl_svc_odata_v4 PUBLIC.
  DATA operation TYPE REF TO if_xco_srvb_operation_factory READ-ONLY.

  METHODS is_published
    IMPORTING io_service_binding     TYPE REF TO if_xco_service_binding
    RETURNING VALUE(rv_is_published) TYPE abap_bool.
ENDINTERFACE.
