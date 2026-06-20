INTERFACE if_xco_cp_json_data_builder PUBLIC.
  METHODS begin_object RETURNING VALUE(ro_builder) TYPE REF TO if_xco_cp_json_data_builder.
  METHODS end_object RETURNING VALUE(ro_builder) TYPE REF TO if_xco_cp_json_data_builder.
  METHODS begin_array RETURNING VALUE(ro_builder) TYPE REF TO if_xco_cp_json_data_builder.
  METHODS end_array RETURNING VALUE(ro_builder) TYPE REF TO if_xco_cp_json_data_builder.
  METHODS add_member IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_builder) TYPE REF TO if_xco_cp_json_data_builder.
  METHODS add_string IMPORTING iv_value TYPE csequence RETURNING VALUE(ro_builder) TYPE REF TO if_xco_cp_json_data_builder.
  METHODS add_boolean IMPORTING iv_value TYPE abap_bool RETURNING VALUE(ro_builder) TYPE REF TO if_xco_cp_json_data_builder.
  METHODS add_number IMPORTING iv_value TYPE numeric RETURNING VALUE(ro_builder) TYPE REF TO if_xco_cp_json_data_builder.
  METHODS get_data RETURNING VALUE(ro_data) TYPE REF TO if_xco_cp_json_data.
ENDINTERFACE.
