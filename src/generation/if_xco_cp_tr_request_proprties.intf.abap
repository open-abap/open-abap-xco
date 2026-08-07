INTERFACE if_xco_cp_tr_request_proprties PUBLIC.
  METHODS get_target
    RETURNING
      VALUE(ro_target) TYPE REF TO if_xco_transport_target.

  METHODS get_last_changed
    RETURNING
      VALUE(ro_last_changed) TYPE REF TO if_xco_cp_tm_moment.
ENDINTERFACE.