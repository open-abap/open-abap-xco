INTERFACE if_xco_cp_gen_devc_s_form PUBLIC.
  TYPES tv_short_description TYPE c LENGTH 60.


  METHODS set_short_description
    IMPORTING
      iv_short_description TYPE tv_short_description
    RETURNING
      VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_devc_s_form.
ENDINTERFACE.
