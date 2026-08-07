INTERFACE if_xco_ao_c_data PUBLIC.
  DATA name TYPE sxco_ao_component_name READ-ONLY.

  METHODS content
    RETURNING
      VALUE(ro_content) TYPE REF TO if_xco_ao_c_data_content.
ENDINTERFACE.