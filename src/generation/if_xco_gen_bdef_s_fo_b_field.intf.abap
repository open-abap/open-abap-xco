INTERFACE if_xco_gen_bdef_s_fo_b_field PUBLIC.
  METHODS set_numbering_managed
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_bdef_s_fo_b_field.
  METHODS set_read_only
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_bdef_s_fo_b_field.
  METHODS set_readonly_update
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_bdef_s_fo_b_field.
ENDINTERFACE.
