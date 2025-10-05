INTERFACE if_xco_cp_software_component_f PUBLIC.

  METHODS
    for_name
      IMPORTING
        iv_name                      TYPE if_xco_software_component=>tv_name
      RETURNING
        VALUE(ro_software_component) TYPE REF TO if_xco_software_component.

ENDINTERFACE.