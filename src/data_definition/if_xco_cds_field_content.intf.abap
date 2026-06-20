INTERFACE if_xco_cds_field_content PUBLIC.
  TYPES: BEGIN OF ts_association,
           target TYPE sxco_cds_object_name,
         END OF ts_association.
  TYPES: BEGIN OF ts_composition,
           target TYPE sxco_cds_object_name,
         END OF ts_composition.
  TYPES: BEGIN OF ts_content,
           alias         TYPE sxco_cds_field_name,
           original_name TYPE sxco_cds_field_name,
           key_indicator TYPE abap_bool,
           association   TYPE ts_association,
           composition   TYPE ts_composition,
         END OF ts_content.

  METHODS get_key_indicator
    RETURNING
      VALUE(rv_key_indicator) TYPE abap_bool.
  METHODS get
    RETURNING VALUE(rs_content) TYPE ts_content.
  METHODS get_type
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_field_type.

ENDINTERFACE.
