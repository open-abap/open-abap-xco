CLASS cl_xco_cp_cs_line_nmbr_flv_fct DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_cs_line_nmbr_flv_fct.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_cs_line_nmbr_flv_fct IMPLEMENTATION.
  METHOD constructor.
    if_xco_cp_cs_line_nmbr_flv_fct~source = NEW lcl_line_number_flavor( ).
    if_xco_cp_cs_line_nmbr_flv_fct~include = NEW lcl_line_number_flavor( ).
  ENDMETHOD.
ENDCLASS.
