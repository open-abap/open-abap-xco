CLASS cl_xco_cp_tm_format_factory DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_time.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_tm_format_factory.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_tm_format_factory IMPLEMENTATION.
  METHOD constructor.
    if_xco_cp_tm_format_factory~abap = NEW #( ).
    if_xco_cp_tm_format_factory~iso_8601_basic = NEW #( ).
    if_xco_cp_tm_format_factory~iso_8601_extended = NEW #( ).
  ENDMETHOD.
ENDCLASS.
