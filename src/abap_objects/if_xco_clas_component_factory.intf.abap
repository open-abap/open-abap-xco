INTERFACE if_xco_clas_component_factory PUBLIC.
  METHODS method
    IMPORTING
      iv_name          TYPE sxco_clas_method_name
    RETURNING
      VALUE(ro_method) TYPE REF TO if_xco_clas_c_method.
ENDINTERFACE.