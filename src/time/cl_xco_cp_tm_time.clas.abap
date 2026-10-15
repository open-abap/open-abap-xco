CLASS cl_xco_cp_tm_time DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_tm_time.

    " raises cx_xco_runtime_exception if iv_time is not a time between 00:00:00 and 23:59:59
    CLASS-METHODS create
      IMPORTING
        iv_time        TYPE t
      RETURNING
        VALUE(ro_time) TYPE REF TO if_xco_cp_tm_time.

    METHODS constructor
      IMPORTING
        iv_time TYPE t.

  PRIVATE SECTION.
    CONSTANTS mc_seconds_per_day TYPE i VALUE 86400.

    DATA mv_time TYPE t.

    CLASS-METHODS seconds
      IMPORTING
        iv_hour           TYPE i
        iv_minute         TYPE i
        iv_second         TYPE i
      RETURNING
        VALUE(rv_seconds) TYPE i.

    METHODS shift
      IMPORTING
        iv_seconds     TYPE i
      RETURNING
        VALUE(ro_time) TYPE REF TO if_xco_cp_tm_time.
ENDCLASS.

CLASS cl_xco_cp_tm_time IMPLEMENTATION.
  METHOD create.
    IF iv_time CN '0123456789' OR iv_time(2) > '23' OR iv_time+2(2) > '59' OR iv_time+4(2) > '59'.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    ro_time = NEW cl_xco_cp_tm_time( iv_time ).
  ENDMETHOD.

  METHOD constructor.
    mv_time = iv_time.
    if_xco_cp_tm_time~hour = iv_time(2).
    if_xco_cp_tm_time~minute = iv_time+2(2).
    if_xco_cp_tm_time~second = iv_time+4(2).
  ENDMETHOD.

  METHOD seconds.
    " each part is reduced to one day first, so that large values cannot overflow
    rv_seconds = ( iv_hour MOD 24 ) * 3600 + ( iv_minute MOD 1440 ) * 60 + iv_second MOD mc_seconds_per_day.
  ENDMETHOD.

  METHOD shift.
    " a time has no date, so the result wraps around midnight
    DATA lv_time TYPE t.

    lv_time = ( mv_time + iv_seconds ) MOD mc_seconds_per_day.
    ro_time = NEW cl_xco_cp_tm_time( lv_time ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_time~as.
    ro_string = xco_cp=>string( io_format->from_time( me ) ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_time~add.
    ro_time = shift( seconds( iv_hour   = iv_hour
                              iv_minute = iv_minute
                              iv_second = iv_second ) ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_time~subtract.
    ro_time = shift( 0 - seconds( iv_hour   = iv_hour
                                  iv_minute = iv_minute
                                  iv_second = iv_second ) ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_time~overwrite.
    DATA(lv_time) = mv_time.

    IF iv_hour IS SUPPLIED.
      lv_time(2) = iv_hour.
    ENDIF.
    IF iv_minute IS SUPPLIED.
      lv_time+2(2) = iv_minute.
    ENDIF.
    IF iv_second IS SUPPLIED.
      lv_time+4(2) = iv_second.
    ENDIF.

    ro_time = create( lv_time ).
  ENDMETHOD.
ENDCLASS.
