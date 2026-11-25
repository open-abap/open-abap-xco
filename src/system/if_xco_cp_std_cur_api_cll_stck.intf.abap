INTERFACE if_xco_cp_std_cur_api_cll_stck PUBLIC.
  METHODS full
    RETURNING
      VALUE(ro_full) TYPE REF TO if_xco_cp_call_stack.
ENDINTERFACE.
