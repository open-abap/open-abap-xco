CLASS cl_xco_date_calculation_fctry DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_time.

  PUBLIC SECTION.
    " the day of the month is kept, a day that does not exist in the resulting month raises an exception
    DATA preserving TYPE REF TO if_xco_date_calculation READ-ONLY.
    " the day of the month is kept, a day that does not exist in the resulting month becomes its last day
    DATA ultimo TYPE REF TO if_xco_date_calculation READ-ONLY.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_date_calculation_fctry IMPLEMENTATION.
  METHOD constructor.
    preserving = NEW lcl_date_calculation( ).
    ultimo = NEW lcl_date_calculation( ).
  ENDMETHOD.
ENDCLASS.
