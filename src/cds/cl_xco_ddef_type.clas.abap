CLASS cl_xco_ddef_type DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA value TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        iv_value TYPE string.
ENDCLASS.

CLASS cl_xco_ddef_type IMPLEMENTATION.
  METHOD constructor.
    value = iv_value.
  ENDMETHOD.
ENDCLASS.
