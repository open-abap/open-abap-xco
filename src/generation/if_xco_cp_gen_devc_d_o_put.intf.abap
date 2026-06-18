INTERFACE if_xco_cp_gen_devc_d_o_put PUBLIC.
  METHODS add_object
    IMPORTING
      iv_name          TYPE csequence
    RETURNING
      VALUE(ro_object) TYPE REF TO if_xco_cp_gen_devc_d_o_put_obj.
  METHODS execute
    RETURNING
      VALUE(ro_result) TYPE REF TO if_xco_gen_o_put_result.
ENDINTERFACE.
