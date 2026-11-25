CLASS cl_xco_string_value DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA value TYPE string READ-ONLY.

    METHODS has_value
      RETURNING
        VALUE(rv_has_value) TYPE abap_bool.

    METHODS get_value
      RETURNING
        VALUE(rv_value) TYPE string.
ENDCLASS.

CLASS cl_xco_string_value IMPLEMENTATION.
  METHOD has_value.
    rv_has_value = xsdbool( value IS NOT INITIAL ).
  ENDMETHOD.

  METHOD get_value.
    rv_value = value.
  ENDMETHOD.
ENDCLASS.
