INTERFACE if_xco_cp_gen_srvb_d_o_put_sct PUBLIC.
  METHODS add_object
    IMPORTING iv_name          TYPE csequence
    RETURNING VALUE(ro_object) TYPE REF TO if_xco_cp_gen_srvb_d_o_put_obj.
ENDINTERFACE.
