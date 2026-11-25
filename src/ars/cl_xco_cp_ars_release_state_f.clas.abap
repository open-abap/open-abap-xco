CLASS cl_xco_cp_ars_release_state_f DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA not_released TYPE REF TO cl_xco_ars_release_state READ-ONLY.
    DATA released     TYPE REF TO cl_xco_ars_release_state READ-ONLY.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_ars_release_state_f IMPLEMENTATION.
  METHOD constructor.
    not_released = NEW #( 'NOT_RELEASED' ).
    released = NEW #( 'RELEASED' ).
  ENDMETHOD.
ENDCLASS.
