CLASS cl_xco_ddef_object_read_sta_f DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA active TYPE REF TO cl_xco_ddef_object_read_state READ-ONLY.
    DATA latest TYPE REF TO cl_xco_ddef_object_read_state READ-ONLY.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_ddef_object_read_sta_f IMPLEMENTATION.
  METHOD constructor.
    active = NEW #( ).
    latest = NEW #( ).
  ENDMETHOD.
ENDCLASS.
