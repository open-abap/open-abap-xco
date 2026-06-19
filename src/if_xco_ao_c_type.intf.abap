INTERFACE if_xco_ao_c_type PUBLIC.
  METHODS content
    RETURNING
      VALUE(ro_content) TYPE REF TO if_xco_ao_c_type_content.
ENDINTERFACE.
