INTERFACE if_xco_cp_transports PUBLIC.
  METHODS create_request
    IMPORTING iv_text           TYPE csequence
    RETURNING VALUE(ro_request) TYPE REF TO if_xco_cp_tr_request.
ENDINTERFACE.
