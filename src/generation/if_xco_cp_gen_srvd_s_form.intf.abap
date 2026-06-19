INTERFACE if_xco_cp_gen_srvd_s_form PUBLIC.
  METHODS set_short_description
    IMPORTING iv_short_description TYPE csequence
    RETURNING VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_srvd_s_form.
ENDINTERFACE.
