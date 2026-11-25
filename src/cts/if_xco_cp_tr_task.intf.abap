INTERFACE if_xco_cp_tr_task PUBLIC.
  INTERFACES if_xco_cp_transport.
  INTERFACES if_xco_tr_entry_source.

  " workaround for some bug in abaplint,
  DATA value TYPE c LENGTH 20.

  METHODS properties
    RETURNING
      VALUE(ro_properties) TYPE REF TO if_xco_cp_tr_task_properties.
ENDINTERFACE.