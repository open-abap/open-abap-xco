CLASS cl_xco_cp_tm_date DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_tm_date.

    " raises cx_xco_runtime_exception if iv_date is not a date between 0001-01-01 and 9999-12-31
    CLASS-METHODS create
      IMPORTING
        iv_date        TYPE d
      RETURNING
        VALUE(ro_date) TYPE REF TO if_xco_cp_tm_date.

    METHODS constructor
      IMPORTING
        iv_date TYPE d.

  PRIVATE SECTION.
    CONSTANTS mc_months_per_year TYPE i VALUE 12.
    CONSTANTS mc_max_year TYPE i VALUE 9999.

    DATA mv_date TYPE d.

    CLASS-METHODS days_in_month
      IMPORTING
        iv_year        TYPE i
        iv_month       TYPE i
      RETURNING
        VALUE(rv_days) TYPE i.

    CLASS-METHODS build
      IMPORTING
        iv_year        TYPE i
        iv_month       TYPE i
        iv_day         TYPE i
      RETURNING
        VALUE(rv_date) TYPE d.

    " days since 0000-03-01 in the proleptic Gregorian calendar the validation follows,
    " ABAP date arithmetic would switch to the Julian calendar before 1582-10-15
    CLASS-METHODS day_number
      IMPORTING
        iv_year              TYPE i
        iv_month             TYPE i
        iv_day               TYPE i
      RETURNING
        VALUE(rv_day_number) TYPE int8.

    CLASS-METHODS from_day_number
      IMPORTING
        iv_day_number  TYPE int8
      RETURNING
        VALUE(rv_date) TYPE d.

    METHODS shift
      IMPORTING
        iv_year        TYPE int8
        iv_month       TYPE int8
        iv_day         TYPE int8
        io_calculation TYPE REF TO if_xco_date_calculation
      RETURNING
        VALUE(ro_date) TYPE REF TO if_xco_cp_tm_date.
ENDCLASS.

CLASS cl_xco_cp_tm_date IMPLEMENTATION.
  METHOD create.
    DATA lv_year TYPE i.
    DATA lv_month TYPE i.
    DATA lv_day TYPE i.

    IF iv_date CN '0123456789'.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    lv_year = iv_date(4).
    lv_month = iv_date+4(2).
    lv_day = iv_date+6(2).

    IF lv_year < 1 OR lv_month < 1 OR lv_month > mc_months_per_year OR lv_day < 1.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    DATA(lv_last_day) = days_in_month( iv_year  = lv_year
                                       iv_month = lv_month ).
    IF lv_day > lv_last_day.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    ro_date = NEW cl_xco_cp_tm_date( iv_date ).
  ENDMETHOD.

  METHOD constructor.
    mv_date = iv_date.
    if_xco_cp_tm_date~year = iv_date(4).
    if_xco_cp_tm_date~month = iv_date+4(2).
    if_xco_cp_tm_date~day = iv_date+6(2).
  ENDMETHOD.

  METHOD days_in_month.
    CASE iv_month.
      WHEN 2.
        IF iv_year MOD 4 = 0 AND ( iv_year MOD 100 <> 0 OR iv_year MOD 400 = 0 ).
          rv_days = 29.
        ELSE.
          rv_days = 28.
        ENDIF.
      WHEN 4 OR 6 OR 9 OR 11.
        rv_days = 30.
      WHEN OTHERS.
        rv_days = 31.
    ENDCASE.
  ENDMETHOD.

  METHOD build.
    DATA lv_year TYPE n LENGTH 4.
    DATA lv_month TYPE n LENGTH 2.
    DATA lv_day TYPE n LENGTH 2.

    lv_year = iv_year.
    lv_month = iv_month.
    lv_day = iv_day.
    rv_date = |{ lv_year }{ lv_month }{ lv_day }|.
  ENDMETHOD.

  METHOD day_number.
    " the year starts in March, so that the leap day is the last day of a year
    DATA(lv_year) = CONV int8( iv_year ).
    DATA(lv_month) = CONV int8( iv_month ) - 3.
    IF lv_month < 0.
      lv_month = lv_month + mc_months_per_year.
      lv_year = lv_year - 1.
    ENDIF.

    rv_day_number = lv_year * 365 + lv_year DIV 4 - lv_year DIV 100 + lv_year DIV 400
      + ( 153 * lv_month + 2 ) DIV 5 + iv_day - 1.
  ENDMETHOD.

  METHOD from_day_number.
    " the inverse of day_number, in cycles of 400 years with 146097 days each
    DATA(lv_cycle) = iv_day_number DIV 146097.
    DATA(lv_day_of_cycle) = iv_day_number MOD 146097.
    DATA(lv_year_of_cycle) = ( lv_day_of_cycle - lv_day_of_cycle DIV 1460 + lv_day_of_cycle DIV 36524
      - lv_day_of_cycle DIV 146096 ) DIV 365.
    DATA(lv_day_of_year) = lv_day_of_cycle
      - ( 365 * lv_year_of_cycle + lv_year_of_cycle DIV 4 - lv_year_of_cycle DIV 100 ).
    DATA(lv_month) = ( 5 * lv_day_of_year + 2 ) DIV 153.
    DATA(lv_day) = lv_day_of_year - ( 153 * lv_month + 2 ) DIV 5 + 1.
    DATA(lv_year) = lv_cycle * 400 + lv_year_of_cycle.

    IF lv_month < 10.
      lv_month = lv_month + 3.
    ELSE.
      lv_month = lv_month - 9.
      lv_year = lv_year + 1.
    ENDIF.

    rv_date = build( iv_year  = CONV #( lv_year )
                     iv_month = CONV #( lv_month )
                     iv_day   = CONV #( lv_day ) ).
  ENDMETHOD.

  METHOD shift.
    " years and months first, the day of the month is then checked against the resulting month,
    " the days are added last; in int8, as the parameters may be any integer
    DATA lv_months TYPE int8.
    DATA lv_year TYPE i.
    DATA lv_month TYPE i.

    lv_months = CONV int8( if_xco_cp_tm_date~year ) * mc_months_per_year + if_xco_cp_tm_date~month - 1
      + iv_year * mc_months_per_year + iv_month.
    IF lv_months < mc_months_per_year OR lv_months DIV mc_months_per_year > mc_max_year.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    lv_year = lv_months DIV mc_months_per_year.
    lv_month = lv_months MOD mc_months_per_year + 1.
    DATA(lv_day) = CONV i( if_xco_cp_tm_date~day ).

    DATA(lv_last_day) = days_in_month( iv_year  = lv_year
                                       iv_month = lv_month ).
    IF lv_day > lv_last_day.
      IF io_calculation <> xco_cp_time=>date_calculation->ultimo.
        RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
      ENDIF.
      lv_day = lv_last_day.
    ENDIF.

    DATA(lv_day_number) = day_number( iv_year  = lv_year
                                      iv_month = lv_month
                                      iv_day   = lv_day ) + iv_day.
    DATA(lv_first_day_number) = day_number( iv_year  = 1
                                            iv_month = 1
                                            iv_day   = 1 ).
    DATA(lv_last_day_number) = day_number( iv_year  = mc_max_year
                                           iv_month = mc_months_per_year
                                           iv_day   = 31 ).
    IF lv_day_number < lv_first_day_number OR lv_day_number > lv_last_day_number.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    ro_date = NEW cl_xco_cp_tm_date( from_day_number( lv_day_number ) ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_date~as.
    ro_string = xco_cp=>string( io_format->from_date( me ) ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_date~add.
    ro_date = shift( iv_year        = CONV #( iv_year )
                     iv_month       = CONV #( iv_month )
                     iv_day         = CONV #( iv_day )
                     io_calculation = io_calculation ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_date~subtract.
    ro_date = shift( iv_year        = 0 - CONV int8( iv_year )
                     iv_month       = 0 - CONV int8( iv_month )
                     iv_day         = 0 - CONV int8( iv_day )
                     io_calculation = io_calculation ).
  ENDMETHOD.

  METHOD if_xco_cp_tm_date~overwrite.
    DATA(lv_date) = mv_date.

    IF iv_year IS SUPPLIED.
      lv_date(4) = iv_year.
    ENDIF.
    IF iv_month IS SUPPLIED.
      lv_date+4(2) = iv_month.
    ENDIF.
    IF iv_day IS SUPPLIED.
      lv_date+6(2) = iv_day.
    ENDIF.

    ro_date = create( lv_date ).
  ENDMETHOD.
ENDCLASS.
