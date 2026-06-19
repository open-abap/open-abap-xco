CLASS xco_cp DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS string
      IMPORTING
        iv_value         TYPE csequence
      RETURNING
        VALUE(ro_string) TYPE REF TO cl_xco_string_builder.
ENDCLASS.

CLASS xco_cp IMPLEMENTATION.
  METHOD string.
    CLEAR ro_string.
  ENDMETHOD.
ENDCLASS.
