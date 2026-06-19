INTERFACE if_xco_cp_gen_patch_obj PUBLIC.
  METHODS create_change_specification
    RETURNING VALUE(ro_specification) TYPE REF TO if_xco_cp_gen_change_spec.
ENDINTERFACE.
