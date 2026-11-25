INTERFACE if_xco_cp_ar_bdef_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name                       TYPE csequence
    RETURNING VALUE(ro_behavior_definition) TYPE REF TO if_xco_behavior_definition.
ENDINTERFACE.
