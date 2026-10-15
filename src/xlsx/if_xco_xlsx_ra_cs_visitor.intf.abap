INTERFACE if_xco_xlsx_ra_cs_visitor PUBLIC.
  METHODS on_start DEFAULT IGNORE
    IMPORTING
      io_ongoing_action TYPE REF TO if_xco_dp_ongoing_action.

  METHODS on_end DEFAULT IGNORE
    IMPORTING
      io_ongoing_action TYPE REF TO if_xco_dp_ongoing_action.

  METHODS visit_cell
    IMPORTING
      io_cell           TYPE REF TO if_xco_xlsx_ra_cell
      io_ongoing_action TYPE REF TO if_xco_dp_ongoing_action.
ENDINTERFACE.
