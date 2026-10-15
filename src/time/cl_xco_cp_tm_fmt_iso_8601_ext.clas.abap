CLASS cl_xco_cp_tm_fmt_iso_8601_ext DEFINITION PUBLIC FINAL CREATE PRIVATE
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

CLASS cl_xco_cp_tm_fmt_iso_8601_ext IMPLEMENTATION.
  METHOD if_xco_cp_tm_date_format~from_date.
    " YYYY-MM-DD, e.g. 2025-01-01
    rv_string = |{ io_date->year }-{ io_date->month }-{ io_date->day }|.
  ENDMETHOD.

  METHOD if_xco_cp_tm_date_format~to_date.
    DATA(lv_string) = CONV string( iv_string ).

    IF strlen( lv_string ) <> 10 OR lv_string+4(1) <> '-' OR lv_string+7(1) <> '-'.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    ro_date = cl_xco_cp_tm_date=>create( CONV d( lv_string(4) && lv_string+5(2) && lv_string+8(2) ) ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_time_format~from_time.
    " HH:MM:SS, e.g. 16:09:07
    rv_string = |{ io_time->hour }:{ io_time->minute }:{ io_time->second }|.
  ENDMETHOD.

  METHOD if_xco_cp_tm_time_format~to_time.
    DATA(lv_string) = CONV string( iv_string ).

    IF strlen( lv_string ) <> 8 OR lv_string+2(1) <> ':' OR lv_string+5(1) <> ':'.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    ro_time = cl_xco_cp_tm_time=>create( CONV t( lv_string(2) && lv_string+3(2) && lv_string+6(2) ) ).
  ENDMETHOD.
ENDCLASS.
