INTERFACE if_xco_cp_transports PUBLIC.
  TYPES tt_requests TYPE STANDARD TABLE OF REF TO if_xco_cp_tr_request WITH DEFAULT KEY.

  METHODS create_request
    IMPORTING iv_text           TYPE csequence
    RETURNING VALUE(ro_request) TYPE REF TO if_xco_cp_tr_request.
  METHODS resolve
    IMPORTING io_resolution        TYPE REF TO object OPTIONAL
    RETURNING VALUE(rt_transports) TYPE tt_requests.
ENDINTERFACE.
