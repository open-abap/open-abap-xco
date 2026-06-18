INTERFACE if_xco_gen_ddls_s_fo_view_ds PUBLIC.
  METHODS set_entity IMPORTING iv_entity TYPE csequence RETURNING VALUE(ro_data_source) TYPE REF TO if_xco_gen_ddls_s_fo_view_ds.
  METHODS set_view_entity IMPORTING iv_entity TYPE csequence RETURNING VALUE(ro_data_source) TYPE REF TO if_xco_gen_ddls_s_fo_view_ds.
  METHODS set_alias IMPORTING iv_alias TYPE csequence RETURNING VALUE(ro_data_source) TYPE REF TO if_xco_gen_ddls_s_fo_view_ds.
ENDINTERFACE.
