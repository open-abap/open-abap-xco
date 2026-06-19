CLASS cl_xco_string_builder DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA value TYPE string READ-ONLY.

    METHODS split
      IMPORTING
        iv_separator     TYPE csequence
      RETURNING
        VALUE(ro_string) TYPE REF TO cl_xco_string_builder.

    METHODS compose
      IMPORTING
        io_composition   TYPE REF TO object
      RETURNING
        VALUE(ro_string) TYPE REF TO cl_xco_string_builder.
ENDCLASS.

CLASS cl_xco_string_builder IMPLEMENTATION.
  METHOD split.
    ro_string = me.
  ENDMETHOD.

  METHOD compose.
    ro_string = me.
  ENDMETHOD.
ENDCLASS.
