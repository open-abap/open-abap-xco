CLASS xco_cp_json DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA data TYPE REF TO if_xco_cp_json_data_factory READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS xco_cp_json IMPLEMENTATION.
  METHOD class_constructor.
    data = NEW cl_xco_cp_json_data_factory( ).
  ENDMETHOD.
ENDCLASS.
