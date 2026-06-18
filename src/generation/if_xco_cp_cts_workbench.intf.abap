INTERFACE if_xco_cp_cts_workbench PUBLIC.
  METHODS create_request
    IMPORTING iv_text           TYPE csequence
    RETURNING VALUE(ro_request) TYPE REF TO if_xco_cp_cts_request.
ENDINTERFACE.
