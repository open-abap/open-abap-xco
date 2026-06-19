CLASS cl_xco_ars_api_state DEFINITION PUBLIC.
  PUBLIC SECTION.

    METHODS get_release_state
      RETURNING
        VALUE(ro_release_state) TYPE REF TO cl_xco_ars_release_state.

    METHODS released
      IMPORTING it_visibility       TYPE STANDARD TABLE
      RETURNING VALUE(ro_api_state) TYPE REF TO cl_xco_ars_api_state.
ENDCLASS.

CLASS cl_xco_ars_api_state IMPLEMENTATION.
  METHOD get_release_state.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD released.
    RETURN. " todo, implement method
  ENDMETHOD.

ENDCLASS.
