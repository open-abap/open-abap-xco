CLASS lcl_software_component DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_software_component_f.
    INTERFACES if_xco_software_component.
    INTERFACES if_xco_ar_filter.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_software_component IMPLEMENTATION.

  METHOD if_xco_cp_software_component_f~get_filter.
    CREATE OBJECT ro_filter TYPE lcl_software_component.
  ENDMETHOD.

  METHOD if_xco_cp_software_component_f~for_name.
    CREATE OBJECT ro_software_component TYPE lcl_software_component.
  ENDMETHOD.

ENDCLASS.