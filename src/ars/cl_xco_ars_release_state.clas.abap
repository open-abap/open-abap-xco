CLASS cl_xco_ars_release_state DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA value TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        iv_value TYPE string.
ENDCLASS.

CLASS cl_xco_ars_release_state IMPLEMENTATION.
  METHOD constructor.
    value = iv_value.
  ENDMETHOD.
ENDCLASS.
