CLASS xco_cp_data_definition DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA type TYPE REF TO cl_xco_ddef_type_f READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS xco_cp_data_definition IMPLEMENTATION.
  METHOD class_constructor.
    type = NEW #( ).
  ENDMETHOD.
ENDCLASS.
