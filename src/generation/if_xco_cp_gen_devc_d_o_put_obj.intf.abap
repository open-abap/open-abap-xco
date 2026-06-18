INTERFACE if_xco_cp_gen_devc_d_o_put_obj PUBLIC.
  METHODS create_form_specification
    RETURNING
      VALUE(ro_form) TYPE REF TO if_xco_cp_gen_devc_s_form.
ENDINTERFACE.
