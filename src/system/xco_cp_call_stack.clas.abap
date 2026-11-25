CLASS xco_cp_call_stack DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-DATA format TYPE REF TO if_xco_cp_cs_format_factory READ-ONLY.
    CLASS-DATA line_number_flavor TYPE REF TO if_xco_cp_cs_line_nmbr_flv_fct READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS xco_cp_call_stack IMPLEMENTATION.
  METHOD class_constructor.
    format = NEW cl_xco_cp_cs_format_factory( ).
    line_number_flavor = NEW cl_xco_cp_cs_line_nmbr_flv_fct( ).
  ENDMETHOD.
ENDCLASS.
