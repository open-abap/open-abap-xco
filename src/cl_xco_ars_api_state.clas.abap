CLASS cl_xco_ars_api_state DEFINITION PUBLIC.
  PUBLIC SECTION.

    METHODS get_release_state
      RETURNING
        VALUE(ro_release_state) TYPE REF TO cl_xco_ars_release_state.
ENDCLASS.

CLASS cl_xco_ars_api_state IMPLEMENTATION.
  METHOD get_release_state.
    RETURN. " todo, implement method
  ENDMETHOD.

ENDCLASS.