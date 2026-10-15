CLASS ltcl_date DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS date
      IMPORTING
        iv_date        TYPE d
      RETURNING
        VALUE(ro_date) TYPE REF TO if_xco_cp_tm_date.

    METHODS iso
      IMPORTING
        io_date          TYPE REF TO if_xco_cp_tm_date
      RETURNING
        VALUE(rv_string) TYPE string.

    METHODS assert_rejected
      IMPORTING
        iv_date TYPE d.

    METHODS components FOR TESTING.
    METHODS leap_years FOR TESTING.
    METHODS invalid_dates FOR TESTING.
    METHODS add_days FOR TESTING.
    METHODS subtract_days FOR TESTING.
    METHODS add_all_components FOR TESTING.
    METHODS add_months_keeps_day FOR TESTING.
    METHODS add_months_crosses_year FOR TESTING.
    METHODS preserving_is_default FOR TESTING.
    METHODS preserving_raises FOR TESTING.
    METHODS ultimo_clamps FOR TESTING.
    METHODS ultimo_keeps_existing_day FOR TESTING.
    METHODS ultimo_subtract FOR TESTING.
    METHODS ultimo_leap_day_years FOR TESTING.
    METHODS negative_add_is_subtract FOR TESTING.
    METHODS out_of_bounds FOR TESTING.
    METHODS overwrite FOR TESTING.
    METHODS gregorian_before_1582 FOR TESTING.
    METHODS huge_values FOR TESTING.

    METHODS assert_shift_rejected
      IMPORTING
        iv_year  TYPE i DEFAULT 0
        iv_month TYPE i DEFAULT 0
        iv_day   TYPE i DEFAULT 0.
ENDCLASS.

CLASS ltcl_date IMPLEMENTATION.
  METHOD date.
    ro_date = xco_cp_time=>date(
      iv_year  = iv_date(4)
      iv_month = iv_date+4(2)
      iv_day   = iv_date+6(2) ).
  ENDMETHOD.

  METHOD iso.
    rv_string = xco_cp_time=>format->iso_8601_extended->from_date( io_date ).
  ENDMETHOD.

  METHOD assert_rejected.
    TRY.
        date( iv_date ).
        cl_abap_unit_assert=>fail( |{ iv_date } accepted| ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD components.
    DATA(lo_date) = xco_cp_time=>date(
      iv_year  = '2024'
      iv_month = '03'
      iv_day   = '07' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_date->year
      exp = '2024' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_date->month
      exp = '03' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_date->day
      exp = '07' ).
  ENDMETHOD.

  METHOD leap_years.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240229' ) )
      exp = `2024-02-29` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20000229' ) )
      exp = `2000-02-29` ).
    assert_rejected( '20250229' ).
    assert_rejected( '19000229' ).
  ENDMETHOD.

  METHOD invalid_dates.
    assert_rejected( '20250230' ).
    assert_rejected( '20250431' ).
    assert_rejected( '20251301' ).
    assert_rejected( '20250001' ).
    assert_rejected( '20250100' ).
    assert_rejected( '00000101' ).
  ENDMETHOD.

  METHOD add_days.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240228' )->add( iv_day = 1 ) )
      exp = `2024-02-29` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20241231' )->add( iv_day = 1 ) )
      exp = `2025-01-01` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250101' )->add( iv_day = 365 ) )
      exp = `2026-01-01` ).
  ENDMETHOD.

  METHOD subtract_days.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240301' )->subtract( iv_day = 1 ) )
      exp = `2024-02-29` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250101' )->subtract( iv_day = 1 ) )
      exp = `2024-12-31` ).
  ENDMETHOD.

  METHOD add_all_components.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240311' )->add( iv_day   = 1
                                          iv_month = 1
                                          iv_year  = 1 ) )
      exp = `2025-04-12` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240311' )->subtract( iv_day   = 1
                                               iv_month = 1
                                               iv_year  = 1 ) )
      exp = `2023-02-10` ).
  ENDMETHOD.

  METHOD add_months_keeps_day.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250115' )->add( iv_month = 1 ) )
      exp = `2025-02-15` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250228' )->add( iv_month = 1 ) )
      exp = `2025-03-28` ).
  ENDMETHOD.

  METHOD add_months_crosses_year.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20251115' )->add( iv_month = 3 ) )
      exp = `2026-02-15` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250215' )->subtract( iv_month = 14 ) )
      exp = `2023-12-15` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250615' )->add( iv_month = 24 ) )
      exp = `2027-06-15` ).
  ENDMETHOD.

  METHOD preserving_is_default.
    TRY.
        date( '20240831' )->add( iv_month = 1 ).
        cl_abap_unit_assert=>fail( '2024-09-31 accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD preserving_raises.
    TRY.
        date( '20240229' )->add( iv_year        = 1
                                 io_calculation = xco_cp_time=>date_calculation->preserving ).
        cl_abap_unit_assert=>fail( '2025-02-29 accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD ultimo_clamps.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240831' )->add( iv_month       = 1
                                          io_calculation = xco_cp_time=>date_calculation->ultimo ) )
      exp = `2024-09-30` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240131' )->add( iv_month       = 1
                                          io_calculation = xco_cp_time=>date_calculation->ultimo ) )
      exp = `2024-02-29` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250131' )->add( iv_month       = 1
                                          io_calculation = xco_cp_time=>date_calculation->ultimo ) )
      exp = `2025-02-28` ).
  ENDMETHOD.

  METHOD ultimo_keeps_existing_day.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250228' )->add( iv_month       = 1
                                          io_calculation = xco_cp_time=>date_calculation->ultimo ) )
      exp = `2025-03-28` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250315' )->add( iv_month       = 1
                                          io_calculation = xco_cp_time=>date_calculation->ultimo ) )
      exp = `2025-04-15` ).
  ENDMETHOD.

  METHOD ultimo_subtract.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250331' )->subtract( iv_month       = 1
                                               io_calculation = xco_cp_time=>date_calculation->ultimo ) )
      exp = `2025-02-28` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240331' )->subtract( iv_month       = 1
                                               io_calculation = xco_cp_time=>date_calculation->ultimo ) )
      exp = `2024-02-29` ).
  ENDMETHOD.

  METHOD ultimo_leap_day_years.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240229' )->add( iv_year        = 1
                                          io_calculation = xco_cp_time=>date_calculation->ultimo ) )
      exp = `2025-02-28` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240229' )->add( iv_year        = 4
                                          io_calculation = xco_cp_time=>date_calculation->ultimo ) )
      exp = `2028-02-29` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20240229' )->subtract( iv_year        = 1
                                               io_calculation = xco_cp_time=>date_calculation->ultimo ) )
      exp = `2023-02-28` ).
  ENDMETHOD.

  METHOD negative_add_is_subtract.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250315' )->add( iv_month = -1
                                          iv_day   = -15 ) )
      exp = `2025-01-31` ).
  ENDMETHOD.

  METHOD out_of_bounds.
    TRY.
        date( '99991231' )->add( iv_day = 1 ).
        cl_abap_unit_assert=>fail( 'day after 9999-12-31 accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    TRY.
        date( '99991215' )->add( iv_month       = 1
                                 io_calculation = xco_cp_time=>date_calculation->ultimo ).
        cl_abap_unit_assert=>fail( 'month after 9999-12 accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    TRY.
        date( '00010101' )->subtract( iv_day = 1 ).
        cl_abap_unit_assert=>fail( 'day before 0001-01-01 accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '99991130' )->add( iv_day = 31 ) )
      exp = `9999-12-31` ).
  ENDMETHOD.

  METHOD overwrite.
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250616' )->overwrite( iv_day = '01' ) )
      exp = `2025-06-01` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '20250616' )->overwrite( iv_year  = '2024'
                                                iv_month = '02'
                                                iv_day   = '29' ) )
      exp = `2024-02-29` ).

    TRY.
        date( '20250616' )->overwrite( iv_day = '31' ).
        cl_abap_unit_assert=>fail( '2025-06-31 accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD gregorian_before_1582.
    " 1500 is a leap year in the Julian calendar only
    assert_rejected( '15000229' ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '15000301' )->subtract( iv_day = 1 ) )
      exp = `1500-02-28` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '15821015' )->subtract( iv_day = 1 ) )
      exp = `1582-10-14` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '00010101' )->add( iv_day = 365 ) )
      exp = `0002-01-01` ).
    cl_abap_unit_assert=>assert_equals(
      act = iso( date( '00010101' )->add( iv_day = 3652058 ) )
      exp = `9999-12-31` ).
  ENDMETHOD.

  METHOD assert_shift_rejected.
    TRY.
        date( '20250616' )->add( iv_year  = iv_year
                                 iv_month = iv_month
                                 iv_day   = iv_day ).
        cl_abap_unit_assert=>fail( |{ iv_year } years, { iv_month } months, { iv_day } days accepted| ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    TRY.
        date( '20250616' )->subtract( iv_year  = iv_year
                                      iv_month = iv_month
                                      iv_day   = iv_day ).
        cl_abap_unit_assert=>fail( |{ iv_year } years, { iv_month } months, { iv_day } days accepted| ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD huge_values.
    assert_shift_rejected( iv_year = 2147483647 ).
    assert_shift_rejected( iv_year = -2147483647 ).
    assert_shift_rejected( iv_month = 2147483647 ).
    assert_shift_rejected( iv_month = -2147483647 ).
    assert_shift_rejected( iv_day = 2147483647 ).
    assert_shift_rejected( iv_day = -2147483647 ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_time DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS time
      IMPORTING
        iv_time        TYPE t
      RETURNING
        VALUE(ro_time) TYPE REF TO if_xco_cp_tm_time.

    METHODS ext
      IMPORTING
        io_time          TYPE REF TO if_xco_cp_tm_time
      RETURNING
        VALUE(rv_string) TYPE string.

    METHODS components FOR TESTING.
    METHODS invalid_times FOR TESTING.
    METHODS add_wraps_midnight FOR TESTING.
    METHODS subtract_wraps_midnight FOR TESTING.
    METHODS overwrite FOR TESTING.
    METHODS overwrite_invalid FOR TESTING.
    METHODS huge_values FOR TESTING.
ENDCLASS.

CLASS ltcl_time IMPLEMENTATION.
  METHOD time.
    ro_time = xco_cp_time=>time(
      iv_hour   = iv_time(2)
      iv_minute = iv_time+2(2)
      iv_second = iv_time+4(2) ).
  ENDMETHOD.

  METHOD ext.
    rv_string = xco_cp_time=>format->iso_8601_extended->from_time( io_time ).
  ENDMETHOD.

  METHOD components.
    DATA(lo_time) = xco_cp_time=>time(
      iv_hour   = '08'
      iv_minute = '34'
      iv_second = '05' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_time->hour
      exp = '08' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_time->minute
      exp = '34' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_time->second
      exp = '05' ).
  ENDMETHOD.

  METHOD invalid_times.
    TRY.
        time( '240000' ).
        cl_abap_unit_assert=>fail( '24:00:00 accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    TRY.
        time( '126000' ).
        cl_abap_unit_assert=>fail( '12:60:00 accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD add_wraps_midnight.
    cl_abap_unit_assert=>assert_equals(
      act = ext( time( '160907' )->add( iv_hour   = 1
                                        iv_minute = 1
                                        iv_second = 1 ) )
      exp = `17:10:08` ).
    cl_abap_unit_assert=>assert_equals(
      act = ext( time( '233000' )->add( iv_hour = 1 ) )
      exp = `00:30:00` ).
  ENDMETHOD.

  METHOD subtract_wraps_midnight.
    cl_abap_unit_assert=>assert_equals(
      act = ext( time( '000000' )->subtract( iv_second = 1 ) )
      exp = `23:59:59` ).
    cl_abap_unit_assert=>assert_equals(
      act = ext( time( '120000' )->subtract( iv_hour = 36 ) )
      exp = `00:00:00` ).
  ENDMETHOD.

  METHOD overwrite.
    cl_abap_unit_assert=>assert_equals(
      act = ext( time( '160907' )->overwrite( iv_second = '00' ) )
      exp = `16:09:00` ).
  ENDMETHOD.

  METHOD overwrite_invalid.
    TRY.
        time( '160907' )->overwrite( iv_hour = '24' ).
        cl_abap_unit_assert=>fail( '24:09:07 accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    TRY.
        time( '160907' )->overwrite( iv_second = '60' ).
        cl_abap_unit_assert=>fail( '16:09:60 accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD huge_values.
    cl_abap_unit_assert=>assert_equals(
      act = ext( time( '000000' )->add( iv_second = 2147483647 ) )
      exp = `03:14:07` ).
    cl_abap_unit_assert=>assert_equals(
      act = ext( time( '160907' )->add( iv_hour = 2147483647 ) )
      exp = `23:09:07` ).
    cl_abap_unit_assert=>assert_equals(
      act = ext( time( '160907' )->subtract( iv_minute = 2147483647 ) )
      exp = `14:02:07` ).
    cl_abap_unit_assert=>assert_equals(
      act = ext( time( '160907' )->subtract( iv_hour   = -2147483647
                                             iv_minute = -2147483647
                                             iv_second = -2147483647 ) )
      exp = ext( time( '160907' )->add( iv_hour   = 2147483647
                                        iv_minute = 2147483647
                                        iv_second = 2147483647 ) ) ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_format DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_date TYPE REF TO if_xco_cp_tm_date.
    DATA mo_time TYPE REF TO if_xco_cp_tm_time.

    METHODS setup.
    METHODS from_date FOR TESTING.
    METHODS from_time FOR TESTING.
    METHODS to_date FOR TESTING.
    METHODS to_time FOR TESTING.
    METHODS to_date_rejects FOR TESTING.
    METHODS to_time_rejects FOR TESTING.

    METHODS assert_time_rejected
      IMPORTING
        io_format TYPE REF TO if_xco_cp_tm_time_format
        iv_string TYPE string.
ENDCLASS.

CLASS ltcl_format IMPLEMENTATION.
  METHOD setup.
    mo_date = xco_cp_time=>date(
      iv_year  = '2025'
      iv_month = '01'
      iv_day   = '02' ).
    mo_time = xco_cp_time=>time(
      iv_hour   = '16'
      iv_minute = '09'
      iv_second = '07' ).
  ENDMETHOD.

  METHOD from_date.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_time=>format->abap->from_date( mo_date )
      exp = `20250102` ).
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_time=>format->iso_8601_basic->from_date( mo_date )
      exp = `20250102` ).
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_time=>format->iso_8601_extended->from_date( mo_date )
      exp = `2025-01-02` ).
  ENDMETHOD.

  METHOD from_time.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_time=>format->abap->from_time( mo_time )
      exp = `160907` ).
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_time=>format->iso_8601_basic->from_time( mo_time )
      exp = `160907` ).
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_time=>format->iso_8601_extended->from_time( mo_time )
      exp = `16:09:07` ).
  ENDMETHOD.

  METHOD to_date.
    DATA(lo_basic) = xco_cp_time=>format->iso_8601_basic->to_date( `20240229` ).
    DATA(lo_extended) = xco_cp_time=>format->iso_8601_extended->to_date( `2024-02-29` ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_basic->day
      exp = '29' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_extended->month
      exp = '02' ).
  ENDMETHOD.

  METHOD to_time.
    DATA(lo_basic) = xco_cp_time=>format->iso_8601_basic->to_time( `160907` ).
    DATA(lo_extended) = xco_cp_time=>format->iso_8601_extended->to_time( `16:09:07` ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_basic->minute
      exp = '09' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_extended->second
      exp = '07' ).
  ENDMETHOD.

  METHOD to_date_rejects.
    TRY.
        xco_cp_time=>format->iso_8601_extended->to_date( `20240229` ).
        cl_abap_unit_assert=>fail( 'basic string accepted as extended' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    TRY.
        xco_cp_time=>format->abap->to_date( `2024AB29` ).
        cl_abap_unit_assert=>fail( 'letters accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD assert_time_rejected.
    TRY.
        io_format->to_time( iv_string ).
        cl_abap_unit_assert=>fail( |{ iv_string } accepted| ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD to_time_rejects.
    assert_time_rejected( io_format = xco_cp_time=>format->iso_8601_extended
                          iv_string = `16:09` ).
    assert_time_rejected( io_format = xco_cp_time=>format->iso_8601_extended
                          iv_string = `16.09.07` ).
    assert_time_rejected( io_format = xco_cp_time=>format->iso_8601_extended
                          iv_string = `24:00:00` ).
    assert_time_rejected( io_format = xco_cp_time=>format->iso_8601_basic
                          iv_string = `1609` ).
    assert_time_rejected( io_format = xco_cp_time=>format->iso_8601_basic
                          iv_string = `240000` ).
    assert_time_rejected( io_format = xco_cp_time=>format->abap
                          iv_string = `16:09:07` ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_time_zone DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS values FOR TESTING.
    METHODS utc_date_and_time FOR TESTING.
ENDCLASS.

CLASS ltcl_time_zone IMPLEMENTATION.
  METHOD values.
    DATA lv_user_time_zone TYPE if_xco_tm_time_zone=>tv_value.

    TRY.
        lv_user_time_zone = cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
        lv_user_time_zone = 'UTC'.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_time=>time_zone->utc->value
      exp = 'UTC' ).
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_time=>time_zone->user->value
      exp = lv_user_time_zone ).
  ENDMETHOD.

  METHOD utc_date_and_time.
    DATA lv_timestamp TYPE tzntstmps VALUE '20250102160907'.

    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_time=>time_zone->utc->get_date( lv_timestamp )
      exp = '20250102' ).
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_time=>time_zone->utc->get_time( lv_timestamp )
      exp = '160907' ).
  ENDMETHOD.
ENDCLASS.
