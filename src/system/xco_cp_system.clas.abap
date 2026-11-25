CLASS xco_cp_system DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA software_component TYPE REF TO if_xco_cp_software_component_f READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS xco_cp_system IMPLEMENTATION.
  METHOD class_constructor.
    CREATE OBJECT software_component TYPE lcl_software_component.
  ENDMETHOD.

ENDCLASS.