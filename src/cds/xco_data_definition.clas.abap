CLASS xco_data_definition DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA object_read_state TYPE REF TO cl_xco_ddef_object_read_sta_f READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS xco_data_definition IMPLEMENTATION.
  METHOD class_constructor.
    object_read_state = NEW #( ).
  ENDMETHOD.
ENDCLASS.
