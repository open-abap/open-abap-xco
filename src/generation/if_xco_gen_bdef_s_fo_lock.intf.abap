INTERFACE if_xco_gen_bdef_s_fo_lock PUBLIC.
  METHODS set_master
    RETURNING VALUE(ro_lock) TYPE REF TO if_xco_gen_bdef_s_fo_lock.
  METHODS set_master_total_etag
    IMPORTING iv_master_total_etag TYPE csequence
    RETURNING VALUE(ro_lock)       TYPE REF TO if_xco_gen_bdef_s_fo_lock.
  METHODS set_dependent_by
    IMPORTING iv_association TYPE csequence
    RETURNING VALUE(ro_lock) TYPE REF TO if_xco_gen_bdef_s_fo_lock.
ENDINTERFACE.
