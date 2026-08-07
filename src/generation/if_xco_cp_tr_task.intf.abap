INTERFACE if_xco_cp_tr_task PUBLIC.
  INTERFACES if_xco_cp_transport.

  ALIASES value FOR if_xco_cp_transport~value.

  METHODS properties
    RETURNING
      VALUE(ro_properties) TYPE REF TO if_xco_cp_tr_task_properties.
ENDINTERFACE.