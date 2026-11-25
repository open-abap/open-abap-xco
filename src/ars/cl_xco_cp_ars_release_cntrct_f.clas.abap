CLASS cl_xco_cp_ars_release_cntrct_f DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA c1 TYPE REF TO cl_xco_ars_release_contract READ-ONLY.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_ars_release_cntrct_f IMPLEMENTATION.
  METHOD constructor.
    c1 = NEW #( 'C1' ).
  ENDMETHOD.
ENDCLASS.
