INTERFACE if_xco_cp_gen_tabl_str_s_form PUBLIC.
  METHODS set_short_description
    IMPORTING iv_short_description TYPE csequence
    RETURNING VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_tabl_str_s_form.
ENDINTERFACE.
