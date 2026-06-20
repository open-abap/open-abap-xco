INTERFACE if_xco_cp_tr_request PUBLIC.
  DATA value TYPE sxco_transport READ-ONLY.
  METHODS get_request RETURNING VALUE(ro_request) TYPE REF TO if_xco_cp_tr_request.
  METHODS exists RETURNING VALUE(rv_exists) TYPE abap_bool.
  METHODS get_status RETURNING VALUE(ro_status) TYPE REF TO cl_xco_transport_status.
ENDINTERFACE.
