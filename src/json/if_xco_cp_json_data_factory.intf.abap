INTERFACE if_xco_cp_json_data_factory PUBLIC.
  METHODS builder
    RETURNING VALUE(ro_builder) TYPE REF TO if_xco_cp_json_data_builder.
  METHODS from_string
    IMPORTING iv_string      TYPE string
    RETURNING VALUE(ro_data) TYPE REF TO if_xco_cp_json_data.
ENDINTERFACE.
