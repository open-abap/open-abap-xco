INTERFACE if_xco_ao_c_type_content PUBLIC.
  METHODS get_typing_method
    RETURNING
      VALUE(ro_method) TYPE REF TO cl_xco_abap_typing_method.

  METHODS get_typing_definition
    RETURNING
      VALUE(ro_definition) TYPE REF TO cl_xco_string_value.
ENDINTERFACE.
