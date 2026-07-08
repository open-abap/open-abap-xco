INTERFACE if_xco_gen_ddls_s_fo_field PUBLIC.
  INTERFACES if_xco_gen_cds_s_fo_ann_target.

  ALIASES add_annotation FOR if_xco_gen_cds_s_fo_ann_target~add_annotation.

  METHODS set_key RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
  METHODS set_alias IMPORTING iv_alias TYPE csequence RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
  METHODS set_type
    IMPORTING io_type         TYPE REF TO if_xco_ad_table_type
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
  METHODS create_association
    IMPORTING iv_target             TYPE csequence
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_ddls_s_fo_assoc.
  METHODS create_composition
    IMPORTING iv_target             TYPE csequence
    RETURNING VALUE(ro_composition) TYPE REF TO if_xco_gen_ddls_s_fo_assoc.
  METHODS set_redirected_to_compos_child
    IMPORTING iv_target       TYPE csequence
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
  METHODS set_redirected_to_parent
    IMPORTING iv_target       TYPE csequence
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
  METHODS set_redirected_to
    IMPORTING iv_target       TYPE csequence
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
  METHODS set_localized
    IMPORTING iv_localized    TYPE abap_bool
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
  METHODS set_virtual
    IMPORTING iv_virtual      TYPE abap_bool
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_s_fo_field.
ENDINTERFACE.
