INTERFACE if_xco_gen_bdef_s_fo_b_auth PUBLIC.
  METHODS set_master
    RETURNING VALUE(ro_authorization) TYPE REF TO if_xco_gen_bdef_s_fo_b_auth.
  METHODS set_dependent_by
    IMPORTING iv_association          TYPE csequence
    RETURNING VALUE(ro_authorization) TYPE REF TO if_xco_gen_bdef_s_fo_b_auth.
ENDINTERFACE.
