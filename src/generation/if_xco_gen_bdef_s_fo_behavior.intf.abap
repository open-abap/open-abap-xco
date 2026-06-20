INTERFACE if_xco_gen_bdef_s_fo_behavior PUBLIC.
  DATA characteristics TYPE REF TO if_xco_gen_bdef_s_fo_characts READ-ONLY.
  DATA lock            TYPE REF TO if_xco_gen_bdef_s_fo_lock READ-ONLY.

  METHODS add_action
    IMPORTING iv_name          TYPE csequence
    RETURNING VALUE(ro_action) TYPE REF TO if_xco_gen_bdef_s_fo_b_action.
  METHODS add_standard_operation
    IMPORTING io_operation        TYPE REF TO object
    RETURNING VALUE(ro_operation) TYPE REF TO if_xco_gen_bdef_s_fo_b_action.
  METHODS add_validation
    IMPORTING iv_name              TYPE csequence
    RETURNING VALUE(ro_validation) TYPE REF TO if_xco_gen_bdef_s_fo_b_validtn.
  METHODS add_determination
    IMPORTING iv_name                 TYPE csequence
    RETURNING VALUE(ro_determination) TYPE REF TO if_xco_gen_bdef_s_fo_b_validtn.
  METHODS add_field
    IMPORTING iv_name         TYPE csequence
    RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_bdef_s_fo_b_field.
  METHODS add_mapping_for
    IMPORTING iv_name           TYPE csequence
    RETURNING VALUE(ro_mapping) TYPE REF TO if_xco_gen_bdef_s_fo_b_mapping.
  METHODS add_association
    IMPORTING iv_name               TYPE csequence
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_bdef_s_fo_assoc.

  METHODS create_association
    IMPORTING iv_name               TYPE csequence
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_bdef_s_fo_assoc.
  METHODS create_composition
    IMPORTING iv_name               TYPE csequence
    RETURNING VALUE(ro_association) TYPE REF TO if_xco_gen_bdef_s_fo_assoc.
ENDINTERFACE.
