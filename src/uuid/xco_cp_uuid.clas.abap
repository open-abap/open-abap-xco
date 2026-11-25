CLASS xco_cp_uuid DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-DATA format TYPE REF TO if_xco_cp_uuid_format_factory READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS xco_cp_uuid IMPLEMENTATION.
  METHOD class_constructor.
    format = NEW cl_xco_cp_uuid_format_factory( ).
  ENDMETHOD.
ENDCLASS.
