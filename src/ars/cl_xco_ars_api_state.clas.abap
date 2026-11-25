CLASS cl_xco_ars_api_state DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        io_release_state TYPE REF TO cl_xco_ars_release_state OPTIONAL.

    METHODS get_release_state
      RETURNING
        VALUE(ro_release_state) TYPE REF TO cl_xco_ars_release_state.

    METHODS released
      IMPORTING it_visibility       TYPE STANDARD TABLE
      RETURNING VALUE(ro_api_state) TYPE REF TO cl_xco_ars_api_state.

  PRIVATE SECTION.
    DATA mo_release_state TYPE REF TO cl_xco_ars_release_state.
ENDCLASS.

CLASS cl_xco_ars_api_state IMPLEMENTATION.
  METHOD constructor.
    mo_release_state = io_release_state.
  ENDMETHOD.

  METHOD get_release_state.
    ro_release_state = mo_release_state.
  ENDMETHOD.

  METHOD released.
    ro_api_state = NEW #( xco_cp_ars=>release_state->released ).
  ENDMETHOD.
ENDCLASS.
