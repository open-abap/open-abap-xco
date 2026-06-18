INTERFACE if_xco_cp_tr_request PUBLIC.
  DATA value TYPE sxco_transport READ-ONLY.
  METHODS get_request RETURNING VALUE(ro_request) TYPE REF TO if_xco_cp_tr_request.
ENDINTERFACE.
