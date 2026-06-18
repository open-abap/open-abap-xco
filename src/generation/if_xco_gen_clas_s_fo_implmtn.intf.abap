INTERFACE if_xco_gen_clas_s_fo_implmtn PUBLIC.
  METHODS add_method
    IMPORTING iv_name          TYPE csequence
    RETURNING VALUE(ro_member) TYPE REF TO if_xco_gen_ao_s_fo_component.
ENDINTERFACE.
