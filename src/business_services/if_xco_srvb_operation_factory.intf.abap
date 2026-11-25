INTERFACE if_xco_srvb_operation_factory PUBLIC.
  METHODS publish
    IMPORTING io_service_binding  TYPE REF TO if_xco_service_binding
    RETURNING VALUE(ro_operation) TYPE REF TO if_xco_srvb_operation.
  METHODS unpublish
    IMPORTING io_service_binding  TYPE REF TO if_xco_service_binding
    RETURNING VALUE(ro_operation) TYPE REF TO if_xco_srvb_operation.
ENDINTERFACE.
