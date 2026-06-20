INTERFACE if_xco_cp_gen_ront_s_form PUBLIC.
  METHODS set_short_description
    IMPORTING iv_short_description TYPE csequence
    RETURNING VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_ront_s_form.
  METHODS set_type_category
    IMPORTING io_type_category TYPE REF TO object
    RETURNING VALUE(ro_form)   TYPE REF TO if_xco_cp_gen_ront_s_form.
  METHODS set_name
    IMPORTING iv_name        TYPE csequence
    RETURNING VALUE(ro_form) TYPE REF TO if_xco_cp_gen_ront_s_form.
ENDINTERFACE.
