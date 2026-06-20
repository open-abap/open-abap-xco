INTERFACE if_xco_cp_transports_factory PUBLIC.
  METHODS where
    IMPORTING it_filters           TYPE STANDARD TABLE OPTIONAL
    RETURNING VALUE(ro_transports) TYPE REF TO if_xco_cp_transports.
  METHODS workbench
    IMPORTING iv_target           TYPE csequence
    RETURNING VALUE(ro_workbench) TYPE REF TO if_xco_cp_transports.
ENDINTERFACE.
