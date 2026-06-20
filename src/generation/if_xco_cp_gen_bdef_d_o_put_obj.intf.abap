INTERFACE if_xco_cp_gen_bdef_d_o_put_obj PUBLIC.
  METHODS set_package
    IMPORTING iv_package       TYPE csequence
    RETURNING VALUE(ro_object) TYPE REF TO if_xco_cp_gen_bdef_d_o_put_obj.
  METHODS create_form_specification
    RETURNING VALUE(ro_form) TYPE REF TO if_xco_cp_gen_bdef_s_form.
ENDINTERFACE.
