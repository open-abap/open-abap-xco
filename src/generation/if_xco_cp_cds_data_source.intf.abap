INTERFACE if_xco_cp_cds_data_source PUBLIC.
  METHODS set_entity IMPORTING iv_entity TYPE csequence RETURNING VALUE(ro_data_source) TYPE REF TO if_xco_cp_cds_data_source.
  METHODS set_view_entity IMPORTING iv_entity TYPE csequence RETURNING VALUE(ro_data_source) TYPE REF TO if_xco_cp_cds_data_source.
  METHODS set_alias IMPORTING iv_alias TYPE csequence RETURNING VALUE(ro_data_source) TYPE REF TO if_xco_cp_cds_data_source.
ENDINTERFACE.
