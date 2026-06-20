INTERFACE if_xco_gen_bdef_s_fo_b_action PUBLIC.
  DATA parameter TYPE REF TO if_xco_gen_bdef_s_fo_b_param READ-ONLY.
  DATA result    TYPE REF TO if_xco_gen_bdef_s_fo_b_result READ-ONLY.

  METHODS set_draft
    RETURNING VALUE(ro_action) TYPE REF TO if_xco_gen_bdef_s_fo_b_action.
  METHODS set_determine
    RETURNING VALUE(ro_action) TYPE REF TO if_xco_gen_bdef_s_fo_b_action.
  METHODS set_extensible
    IMPORTING iv_extensible    TYPE abap_bool DEFAULT abap_true
    RETURNING VALUE(ro_action) TYPE REF TO if_xco_gen_bdef_s_fo_b_action.
  METHODS set_features_instance
    RETURNING VALUE(ro_action) TYPE REF TO if_xco_gen_bdef_s_fo_b_action.
  METHODS set_use
    RETURNING VALUE(ro_action) TYPE REF TO if_xco_gen_bdef_s_fo_b_action.
ENDINTERFACE.
