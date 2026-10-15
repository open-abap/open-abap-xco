CLASS cl_xco_cp_tm_fmt_iso_8601_bsc DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_cp_tm_format_factory.

  PUBLIC SECTION.
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

CLASS cl_xco_cp_tm_fmt_iso_8601_bsc IMPLEMENTATION.
  METHOD if_xco_cp_tm_date_format~from_date.
    " YYYYMMDD, e.g. 20250101
    rv_string = |{ io_date->year }{ io_date->month }{ io_date->day }|.
  ENDMETHOD.

  METHOD if_xco_cp_tm_date_format~to_date.
    DATA(lv_string) = CONV string( iv_string ).

    IF strlen( lv_string ) <> 8.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    ro_date = cl_xco_cp_tm_date=>create( CONV d( lv_string ) ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_time_format~from_time.
    " HHMMSS, e.g. 160907
    rv_string = |{ io_time->hour }{ io_time->minute }{ io_time->second }|.
  ENDMETHOD.

  METHOD if_xco_cp_tm_time_format~to_time.
    DATA(lv_string) = CONV string( iv_string ).

    IF strlen( lv_string ) <> 6.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    ro_time = cl_xco_cp_tm_time=>create( CONV t( lv_string ) ).
  ENDMETHOD.
ENDCLASS.
