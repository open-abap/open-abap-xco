INTERFACE if_xco_cp_gen_nont_s_form PUBLIC.
  METHODS set_short_description
    IMPORTING iv_short_description TYPE csequence
    RETURNING VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_nont_s_form.
  METHODS set_name
    IMPORTING iv_name        TYPE csequence
    RETURNING VALUE(ro_form) TYPE REF TO if_xco_cp_gen_nont_s_form.
  METHODS set_sap_object_type
    IMPORTING iv_sap_object_type TYPE csequence
    RETURNING VALUE(ro_form)     TYPE REF TO if_xco_cp_gen_nont_s_form.
  METHODS set_root_node
    IMPORTING iv_root_node   TYPE abap_bool
    RETURNING VALUE(ro_form) TYPE REF TO if_xco_cp_gen_nont_s_form.
ENDINTERFACE.
