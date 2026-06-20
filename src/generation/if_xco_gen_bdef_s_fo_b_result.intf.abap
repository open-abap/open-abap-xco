INTERFACE if_xco_gen_bdef_s_fo_b_result PUBLIC.
  METHODS set_cardinality
    IMPORTING io_cardinality   TYPE REF TO object
    RETURNING VALUE(ro_result) TYPE REF TO if_xco_gen_bdef_s_fo_b_result.
  METHODS set_self
    RETURNING VALUE(ro_result) TYPE REF TO if_xco_gen_bdef_s_fo_b_result.
ENDINTERFACE.
