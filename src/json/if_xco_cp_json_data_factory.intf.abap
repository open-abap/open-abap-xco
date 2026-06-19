INTERFACE if_xco_cp_json_data_factory PUBLIC.
  METHODS builder
    RETURNING VALUE(ro_builder) TYPE REF TO if_xco_cp_json_data_builder.
ENDINTERFACE.
