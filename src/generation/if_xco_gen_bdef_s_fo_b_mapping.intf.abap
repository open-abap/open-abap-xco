INTERFACE if_xco_gen_bdef_s_fo_b_mapping PUBLIC.
  TYPES: BEGIN OF ts_field_mapping,
           dbtable_field  TYPE sxco_ad_field_name,
           cds_view_field TYPE sxco_ad_field_name,
         END OF ts_field_mapping.
  TYPES tt_field_mapping TYPE HASHED TABLE OF ts_field_mapping WITH UNIQUE KEY dbtable_field.

  METHODS set_extensible
    RETURNING VALUE(ro_mapping) TYPE REF TO if_xco_gen_bdef_s_fo_b_mapping.
  METHODS set_corresponding
    RETURNING VALUE(ro_mapping) TYPE REF TO if_xco_gen_bdef_s_fo_b_mapping.
  METHODS set_field_mapping
    IMPORTING it_field_mappings TYPE tt_field_mapping
    RETURNING VALUE(ro_mapping) TYPE REF TO if_xco_gen_bdef_s_fo_b_mapping.
  METHODS set_control
    IMPORTING iv_control        TYPE csequence
    RETURNING VALUE(ro_mapping) TYPE REF TO if_xco_gen_bdef_s_fo_b_mapping.
ENDINTERFACE.
