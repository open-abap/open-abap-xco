INTERFACE if_xco_gen_bdef_s_fo_b_param PUBLIC.
  METHODS set_entity
    IMPORTING iv_entity           TYPE csequence
    RETURNING VALUE(ro_parameter) TYPE REF TO if_xco_gen_bdef_s_fo_b_param.
ENDINTERFACE.
