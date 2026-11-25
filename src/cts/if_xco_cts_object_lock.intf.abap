INTERFACE if_xco_cts_object_lock PUBLIC.
  METHODS exists
    RETURNING VALUE(rv_exists) TYPE abap_bool.

  METHODS get_transport
    RETURNING VALUE(rv_transport) TYPE sxco_transport.
ENDINTERFACE.
