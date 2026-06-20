INTERFACE if_xco_cp_gen_bdef_s_form PUBLIC.
  TYPES tt_extensible_options TYPE STANDARD TABLE OF REF TO object WITH DEFAULT KEY.

  METHODS set_short_description
    IMPORTING iv_short_description TYPE csequence
    RETURNING VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_bdef_s_form.
  METHODS set_extensible
    RETURNING VALUE(ro_form) TYPE REF TO if_xco_cp_gen_bdef_s_form.
  METHODS set_extensible_options
    IMPORTING it_options     TYPE tt_extensible_options
    RETURNING VALUE(ro_form) TYPE REF TO if_xco_cp_gen_bdef_s_form.
  METHODS set_implementation_type
    IMPORTING io_implementation_type TYPE REF TO object
    RETURNING VALUE(ro_form)         TYPE REF TO if_xco_cp_gen_bdef_s_form.
  METHODS set_implementation_class
    IMPORTING iv_class       TYPE csequence
    RETURNING VALUE(ro_form) TYPE REF TO if_xco_cp_gen_bdef_s_form.
  METHODS set_draft_enabled
    IMPORTING iv_enabled     TYPE abap_bool
    RETURNING VALUE(ro_form) TYPE REF TO if_xco_cp_gen_bdef_s_form.
  METHODS add_behavior
    IMPORTING iv_name            TYPE csequence
    RETURNING VALUE(ro_behavior) TYPE REF TO if_xco_gen_bdef_s_fo_behavior.
  METHODS add_local_class
    IMPORTING iv_name               TYPE csequence
    RETURNING VALUE(ro_local_class) TYPE REF TO if_xco_gen_clas_s_form.
  METHODS remove_local_class
    IMPORTING iv_name        TYPE csequence
    RETURNING VALUE(ro_form) TYPE REF TO if_xco_cp_gen_bdef_s_form.
ENDINTERFACE.
