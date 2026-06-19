INTERFACE if_xco_cts_object PUBLIC.
  METHODS get_lock
    RETURNING VALUE(ro_lock) TYPE REF TO if_xco_cts_lock.
ENDINTERFACE.
