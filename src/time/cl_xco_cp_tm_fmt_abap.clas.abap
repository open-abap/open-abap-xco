CLASS cl_xco_cp_tm_fmt_abap DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_cp_tm_format_factory.

  PUBLIC SECTION.
    " dates and times look the same in the ABAP format and the basic ISO 8601 format,
    " so they are delegated to iso_8601_basic
    INTERFACES:
      if_xco_cp_tm_date_format,
      if_xco_cp_tm_time_format.
      " if_xco_cp_tm_moment_format.

    ALIASES:
      to_date FOR if_xco_cp_tm_date_format~to_date,
      from_date FOR if_xco_cp_tm_date_format~from_date,
      to_time FOR if_xco_cp_tm_time_format~to_time,
      from_time FOR if_xco_cp_tm_time_format~from_time.
      " to_moment FOR if_xco_cp_tm_moment_format~to_moment,
      " from_moment FOR if_xco_cp_tm_moment_format~from_moment.
ENDCLASS.

CLASS cl_xco_cp_tm_fmt_abap IMPLEMENTATION.
  METHOD if_xco_cp_tm_date_format~from_date.
    rv_string = xco_cp_time=>format->iso_8601_basic->from_date( io_date ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_date_format~to_date.
    ro_date = xco_cp_time=>format->iso_8601_basic->to_date( iv_string ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_time_format~from_time.
    rv_string = xco_cp_time=>format->iso_8601_basic->from_time( io_time ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_time_format~to_time.
    ro_time = xco_cp_time=>format->iso_8601_basic->to_time( iv_string ).
  ENDMETHOD.
ENDCLASS.
