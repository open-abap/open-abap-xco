INTERFACE if_xco_cds_assoc_content PUBLIC.
  METHODS get_to_parent_indicator
    RETURNING VALUE(rv_to_parent) TYPE abap_bool.
  METHODS get_target
    RETURNING VALUE(rv_target) TYPE sxco_cds_object_name.
ENDINTERFACE.
