INTERFACE if_xco_clas_definition_content PUBLIC.

  METHODS get_superclass
    RETURNING
      VALUE(ro_superclass) TYPE REF TO if_xco_ao_class.

  METHODS get_interfaces
    RETURNING
      VALUE(rt_interfaces) TYPE sxco_t_ao_interfaces.

ENDINTERFACE.