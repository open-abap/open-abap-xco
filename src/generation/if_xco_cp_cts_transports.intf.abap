INTERFACE if_xco_cp_cts_transports PUBLIC.
  METHODS workbench
    IMPORTING iv_target           TYPE csequence
    RETURNING VALUE(ro_workbench) TYPE REF TO if_xco_cp_cts_workbench.
ENDINTERFACE.
