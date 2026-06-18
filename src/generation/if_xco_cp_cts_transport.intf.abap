INTERFACE if_xco_cp_cts_transport PUBLIC.
  METHODS for
    IMPORTING iv_transport      TYPE sxco_transport
    RETURNING VALUE(ro_request) TYPE REF TO if_xco_cp_cts_request.
ENDINTERFACE.
