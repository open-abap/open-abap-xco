CLASS cl_xco_cp_std_current DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_std_current.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_std_current IMPLEMENTATION.
  METHOD constructor.
    if_xco_cp_std_current~call_stack = NEW cl_xco_cp_std_cur_api_cll_stck( ).
  ENDMETHOD.
ENDCLASS.
