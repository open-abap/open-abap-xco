INTERFACE if_xco_cts_lock PUBLIC.
  METHODS get_transport
    RETURNING VALUE(rv_transport) TYPE sxco_transport.
ENDINTERFACE.
