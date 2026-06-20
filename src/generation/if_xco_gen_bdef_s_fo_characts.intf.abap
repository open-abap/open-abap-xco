INTERFACE if_xco_gen_bdef_s_fo_characts PUBLIC.
  DATA authorization TYPE REF TO if_xco_gen_bdef_s_fo_b_auth READ-ONLY.
  DATA etag          TYPE REF TO if_xco_gen_bdef_s_fo_b_etag READ-ONLY.
  DATA lock          TYPE REF TO if_xco_gen_bdef_s_fo_lock READ-ONLY.

  METHODS set_alias
    IMPORTING iv_alias                  TYPE csequence
    RETURNING VALUE(ro_characteristics) TYPE REF TO if_xco_gen_bdef_s_fo_characts.
  METHODS set_implementation_class
    IMPORTING iv_class                  TYPE csequence
    RETURNING VALUE(ro_characteristics) TYPE REF TO if_xco_gen_bdef_s_fo_characts.
  METHODS set_extensible
    RETURNING VALUE(ro_characteristics) TYPE REF TO if_xco_gen_bdef_s_fo_characts.
  METHODS set_draft_enabled
    IMPORTING iv_enabled                TYPE abap_bool
    RETURNING VALUE(ro_characteristics) TYPE REF TO if_xco_gen_bdef_s_fo_characts.
  METHODS set_with_additional_save
    RETURNING VALUE(ro_characteristics) TYPE REF TO if_xco_gen_bdef_s_fo_characts.
  METHODS set_with_unmanaged_save
    RETURNING VALUE(ro_characteristics) TYPE REF TO if_xco_gen_bdef_s_fo_characts.
  METHODS set_draft_table
    IMPORTING iv_table                  TYPE csequence
    RETURNING VALUE(ro_characteristics) TYPE REF TO if_xco_gen_bdef_s_fo_characts.
  METHODS set_query
    IMPORTING iv_query                  TYPE csequence
    RETURNING VALUE(ro_characteristics) TYPE REF TO if_xco_gen_bdef_s_fo_characts.
  METHODS set_persistent_table
    IMPORTING iv_table                  TYPE csequence
    RETURNING VALUE(ro_characteristics) TYPE REF TO if_xco_gen_bdef_s_fo_characts.
ENDINTERFACE.
