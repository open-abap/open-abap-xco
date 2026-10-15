CLASS ltcl_value_transformation DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_best_effort TYPE REF TO cl_xco_xlsx_value_trnsfrmtn.
    DATA mo_identity TYPE REF TO cl_xco_xlsx_value_trnsfrmtn.
    DATA mo_string_value TYPE REF TO cl_xco_xlsx_value_trnsfrmtn.

    METHODS setup.

    METHODS write_boolean FOR TESTING.
    METHODS write_texts FOR TESTING.
    METHODS write_integers FOR TESTING.
    METHODS write_decimals FOR TESTING.
    METHODS write_date FOR TESTING.
    METHODS write_date_1900 FOR TESTING.
    METHODS write_invalid_date FOR TESTING.
    METHODS write_time FOR TESTING.
    METHODS write_unsupported FOR TESTING.
    METHODS read_identity FOR TESTING.
    METHODS read_string_value FOR TESTING.
    METHODS read_best_effort FOR TESTING.
    METHODS read_date FOR TESTING.
    METHODS read_date_1900 FOR TESTING.
    METHODS read_date_from_text FOR TESTING.
    METHODS read_time FOR TESTING.
    METHODS read_without_value FOR TESTING.

    METHODS assert_written
      IMPORTING
        iv_field TYPE any
        iv_type  TYPE cl_xco_xlsx_file=>ty_type
        iv_value TYPE string
        iv_style TYPE i DEFAULT cl_xco_xlsx_file=>gc_style-none.

    METHODS assert_write_fails
      IMPORTING
        iv_field TYPE any.

    METHODS assert_round_trip
      IMPORTING
        iv_field TYPE any.

    METHODS assert_read_fails
      IMPORTING
        io_transformation TYPE REF TO cl_xco_xlsx_value_trnsfrmtn
        is_cell           TYPE cl_xco_xlsx_file=>ty_cell
      CHANGING
        cv_field          TYPE any.

    METHODS number
      IMPORTING
        iv_value       TYPE string
      RETURNING
        VALUE(rs_cell) TYPE cl_xco_xlsx_file=>ty_cell.

    METHODS text
      IMPORTING
        iv_value       TYPE string
      RETURNING
        VALUE(rs_cell) TYPE cl_xco_xlsx_file=>ty_cell.
ENDCLASS.

CLASS ltcl_value_transformation IMPLEMENTATION.
  METHOD setup.
    DATA(lo_read) = xco_cp_xlsx_read_access=>value_transformation.
    mo_best_effort ?= lo_read->best_effort->if_xco_xlsx_ra_vt_cell_value~get_implementation( ).
    mo_identity ?= lo_read->identity->if_xco_xlsx_ra_vt_cell_value~get_implementation( ).
    mo_string_value ?= lo_read->string_value->if_xco_xlsx_ra_vt_cell_value~get_implementation( ).
  ENDMETHOD.

  METHOD write_boolean.
    assert_written( iv_field = abap_true
                    iv_type  = cl_xco_xlsx_file=>gc_type-boolean
                    iv_value = `1` ).
    assert_written( iv_field = abap_false
                    iv_type  = cl_xco_xlsx_file=>gc_type-boolean
                    iv_value = `0` ).
  ENDMETHOD.

  METHOD write_texts.
    DATA lv_char TYPE c LENGTH 10 VALUE 'text'.
    DATA lv_numc TYPE n LENGTH 5 VALUE '00042'.
    DATA lv_flag TYPE c LENGTH 1 VALUE 'X'.

    assert_written( iv_field = lv_char
                    iv_type  = cl_xco_xlsx_file=>gc_type-string
                    iv_value = `text` ).
    assert_written( iv_field = lv_numc
                    iv_type  = cl_xco_xlsx_file=>gc_type-string
                    iv_value = `00042` ).
    assert_written( iv_field = lv_flag
                    iv_type  = cl_xco_xlsx_file=>gc_type-string
                    iv_value = `X` ).
    assert_written( iv_field = ` both ends `
                    iv_type  = cl_xco_xlsx_file=>gc_type-string
                    iv_value = ` both ends ` ).
    " an empty text writes no cell
    assert_written( iv_field = ``
                    iv_type  = ``
                    iv_value = `` ).
  ENDMETHOD.

  METHOD write_integers.
    DATA lv_int TYPE i VALUE -42.
    DATA lv_int1 TYPE int1 VALUE 200.
    DATA lv_int2 TYPE int2 VALUE -300.
    DATA lv_int8 TYPE int8 VALUE 3000000000.

    assert_written( iv_field = lv_int
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `-42` ).
    assert_written( iv_field = lv_int1
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `200` ).
    assert_written( iv_field = lv_int2
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `-300` ).
    assert_written( iv_field = lv_int8
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `3000000000` ).
    assert_round_trip( lv_int1 ).
    assert_round_trip( lv_int2 ).
    assert_round_trip( lv_int8 ).
  ENDMETHOD.

  METHOD write_decimals.
    DATA lv_packed TYPE p LENGTH 9 DECIMALS 2 VALUE '-1234.5'.
    DATA lv_float TYPE f VALUE '1.5'.
    DATA lv_small TYPE f VALUE '-0.001'.
    DATA lv_large TYPE f VALUE '1E20'.
    DATA lv_decfloat TYPE decfloat34 VALUE '123.456'.
    DATA lv_tiny TYPE decfloat34 VALUE '-1E-10'.

    assert_written( iv_field = lv_packed
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `-1234.50` ).
    assert_written( iv_field = lv_float
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `1.5` ).
    assert_written( iv_field = lv_decfloat
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `123.456` ).
    assert_round_trip( lv_packed ).
    assert_round_trip( lv_float ).
    assert_round_trip( lv_small ).
    assert_round_trip( lv_large ).
    assert_round_trip( lv_decfloat ).
    assert_round_trip( lv_tiny ).
  ENDMETHOD.

  METHOD write_date.
    DATA lv_date TYPE d.

    lv_date = '20250120'.
    assert_written( iv_field = lv_date
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `45677`
                    iv_style = cl_xco_xlsx_file=>gc_style-date ).
    CLEAR lv_date.
    assert_written( iv_field = lv_date
                    iv_type  = ``
                    iv_value = `` ).
  ENDMETHOD.

  METHOD write_date_1900.
    " Excel's day 60 is the 1900-02-29 that did not exist
    assert_written( iv_field = CONV d( '19000101' )
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `1`
                    iv_style = cl_xco_xlsx_file=>gc_style-date ).
    assert_written( iv_field = CONV d( '19000228' )
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `59`
                    iv_style = cl_xco_xlsx_file=>gc_style-date ).
    assert_written( iv_field = CONV d( '19000301' )
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `61`
                    iv_style = cl_xco_xlsx_file=>gc_style-date ).
    assert_round_trip( CONV d( '19000101' ) ).
    assert_round_trip( CONV d( '19000228' ) ).
    assert_round_trip( CONV d( '19000301' ) ).
  ENDMETHOD.

  METHOD write_invalid_date.
    assert_write_fails( CONV d( '18991231' ) ).
    assert_write_fails( CONV d( '20251399' ) ).
    assert_write_fails( CONV d( '20250230' ) ).
  ENDMETHOD.

  METHOD write_time.
    assert_written( iv_field = CONV t( '120000' )
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `0.5`
                    iv_style = cl_xco_xlsx_file=>gc_style-time ).
    assert_written( iv_field = CONV t( '000000' )
                    iv_type  = cl_xco_xlsx_file=>gc_type-number
                    iv_value = `0`
                    iv_style = cl_xco_xlsx_file=>gc_style-time ).
    assert_round_trip( CONV t( '103015' ) ).
    assert_round_trip( CONV t( '235959' ) ).
    assert_write_fails( CONV t( '250000' ) ).
  ENDMETHOD.

  METHOD write_unsupported.
    TYPES:
      BEGIN OF ty_structure,
        field TYPE i,
      END OF ty_structure.
    DATA lv_xstring TYPE xstring VALUE 'FF'.
    DATA ls_structure TYPE ty_structure.
    DATA lr_reference TYPE REF TO i.

    assert_write_fails( lv_xstring ).
    assert_write_fails( ls_structure ).
    assert_write_fails( lr_reference ).
  ENDMETHOD.

  METHOD read_identity.
    " the value as stored in the file
    DATA lv_string TYPE string.
    DATA lv_flag TYPE abap_bool.

    mo_identity->read( EXPORTING is_cell  = number( `-1.5E-3` )
                       CHANGING  cv_field = lv_string ).
    cl_abap_unit_assert=>assert_equals( act = lv_string
                                        exp = `-1.5E-3` ).
    mo_identity->read( EXPORTING is_cell  = VALUE #( type = cl_xco_xlsx_file=>gc_type-boolean value = `1` )
                       CHANGING  cv_field = lv_flag ).
    cl_abap_unit_assert=>assert_equals( act = lv_flag
                                        exp = '1' ).
  ENDMETHOD.

  METHOD read_string_value.
    DATA lv_string TYPE string.
    DATA lv_char TYPE c LENGTH 10.
    DATA lv_int TYPE i.

    mo_string_value->read( EXPORTING is_cell  = VALUE #( type = cl_xco_xlsx_file=>gc_type-boolean value = `1` )
                           CHANGING  cv_field = lv_string ).
    cl_abap_unit_assert=>assert_equals( act = lv_string
                                        exp = `TRUE` ).
    mo_string_value->read( EXPORTING is_cell  = number( `-1234.5` )
                           CHANGING  cv_field = lv_char ).
    cl_abap_unit_assert=>assert_equals( act = lv_char
                                        exp = '-1234.5' ).
    " for character-like fields only
    assert_read_fails( EXPORTING io_transformation = mo_string_value
                                 is_cell           = number( `1` )
                       CHANGING  cv_field          = lv_int ).
  ENDMETHOD.

  METHOD read_best_effort.
    DATA lv_packed TYPE p LENGTH 9 DECIMALS 2.
    DATA lv_decfloat TYPE decfloat34.
    DATA lv_flag TYPE abap_bool.
    DATA lv_int TYPE i.

    mo_best_effort->read( EXPORTING is_cell  = number( `-1234.5` )
                          CHANGING  cv_field = lv_packed ).
    cl_abap_unit_assert=>assert_equals( act = lv_packed
                                        exp = '-1234.50' ).
    mo_best_effort->read( EXPORTING is_cell  = number( `1.5E-3` )
                          CHANGING  cv_field = lv_decfloat ).
    cl_abap_unit_assert=>assert_equals( act = lv_decfloat
                                        exp = '0.0015' ).
    mo_best_effort->read( EXPORTING is_cell  = VALUE #( type = cl_xco_xlsx_file=>gc_type-boolean value = `1` )
                          CHANGING  cv_field = lv_flag ).
    cl_abap_unit_assert=>assert_equals( act = lv_flag
                                        exp = abap_true ).
    mo_best_effort->read( EXPORTING is_cell  = VALUE #( type = cl_xco_xlsx_file=>gc_type-boolean value = `0` )
                          CHANGING  cv_field = lv_flag ).
    cl_abap_unit_assert=>assert_equals( act = lv_flag
                                        exp = abap_false ).
    assert_read_fails( EXPORTING io_transformation = mo_best_effort
                                 is_cell           = text( `abc` )
                       CHANGING  cv_field          = lv_int ).
  ENDMETHOD.

  METHOD read_date.
    DATA lv_date TYPE d.

    mo_best_effort->read( EXPORTING is_cell  = number( `46234.75` )
                          CHANGING  cv_field = lv_date ).
    cl_abap_unit_assert=>assert_equals( act = lv_date
                                        exp = '20260731' ).
    assert_read_fails( EXPORTING io_transformation = mo_best_effort
                                 is_cell           = number( `0.5` )
                       CHANGING  cv_field          = lv_date ).
  ENDMETHOD.

  METHOD read_date_1900.
    DATA lv_date TYPE d.

    mo_best_effort->read( EXPORTING is_cell  = number( `1` )
                          CHANGING  cv_field = lv_date ).
    cl_abap_unit_assert=>assert_equals( act = lv_date
                                        exp = '19000101' ).
    mo_best_effort->read( EXPORTING is_cell  = number( `59` )
                          CHANGING  cv_field = lv_date ).
    cl_abap_unit_assert=>assert_equals( act = lv_date
                                        exp = '19000228' ).
    mo_best_effort->read( EXPORTING is_cell  = number( `61` )
                          CHANGING  cv_field = lv_date ).
    cl_abap_unit_assert=>assert_equals( act = lv_date
                                        exp = '19000301' ).
    " 1900-02-29 does not exist
    assert_read_fails( EXPORTING io_transformation = mo_best_effort
                                 is_cell           = number( `60` )
                       CHANGING  cv_field          = lv_date ).
  ENDMETHOD.

  METHOD read_date_from_text.
    DATA lv_date TYPE d.

    mo_best_effort->read( EXPORTING is_cell  = text( `20240229` )
                          CHANGING  cv_field = lv_date ).
    cl_abap_unit_assert=>assert_equals( act = lv_date
                                        exp = '20240229' ).
    mo_best_effort->read( EXPORTING is_cell  = text( `2025-01-20T10:30:00` )
                          CHANGING  cv_field = lv_date ).
    cl_abap_unit_assert=>assert_equals( act = lv_date
                                        exp = '20250120' ).
    assert_read_fails( EXPORTING io_transformation = mo_best_effort
                                 is_cell           = text( `20251399` )
                       CHANGING  cv_field          = lv_date ).
    assert_read_fails( EXPORTING io_transformation = mo_best_effort
                                 is_cell           = text( `20 January` )
                       CHANGING  cv_field          = lv_date ).
  ENDMETHOD.

  METHOD read_time.
    DATA lv_time TYPE t.

    mo_best_effort->read( EXPORTING is_cell  = number( `0.4376736111111111` )
                          CHANGING  cv_field = lv_time ).
    cl_abap_unit_assert=>assert_equals( act = lv_time
                                        exp = '103015' ).
    " the date part of a date and time is ignored
    mo_best_effort->read( EXPORTING is_cell  = number( `45677.99998842592` )
                          CHANGING  cv_field = lv_time ).
    cl_abap_unit_assert=>assert_equals( act = lv_time
                                        exp = '235959' ).
    mo_best_effort->read( EXPORTING is_cell  = text( `10:30:15` )
                          CHANGING  cv_field = lv_time ).
    cl_abap_unit_assert=>assert_equals( act = lv_time
                                        exp = '103015' ).
    assert_read_fails( EXPORTING io_transformation = mo_best_effort
                                 is_cell           = text( `25:00:00` )
                       CHANGING  cv_field          = lv_time ).
  ENDMETHOD.

  METHOD read_without_value.
    DATA lv_string TYPE string VALUE `old`.

    mo_best_effort->read( EXPORTING is_cell  = VALUE #( )
                          CHANGING  cv_field = lv_string ).

    cl_abap_unit_assert=>assert_initial( lv_string ).
  ENDMETHOD.

  METHOD assert_written.
    DATA(ls_cell) = mo_best_effort->write( iv_field ).

    cl_abap_unit_assert=>assert_equals( act = ls_cell-type
                                        exp = iv_type ).
    cl_abap_unit_assert=>assert_equals( act = ls_cell-value
                                        exp = iv_value ).
    cl_abap_unit_assert=>assert_equals( act = ls_cell-style
                                        exp = iv_style ).
  ENDMETHOD.

  METHOD assert_write_fails.
    TRY.
        mo_best_effort->write( iv_field ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD assert_round_trip.
    DATA lr_read TYPE REF TO data.
    FIELD-SYMBOLS <lv_read> TYPE any.

    CREATE DATA lr_read LIKE iv_field.
    ASSIGN lr_read->* TO <lv_read>.
    mo_best_effort->read( EXPORTING is_cell  = mo_best_effort->write( iv_field )
                          CHANGING  cv_field = <lv_read> ).

    cl_abap_unit_assert=>assert_equals( act = <lv_read>
                                        exp = iv_field ).
  ENDMETHOD.

  METHOD assert_read_fails.
    TRY.
        io_transformation->read( EXPORTING is_cell  = is_cell
                                 CHANGING  cv_field = cv_field ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD number.
    rs_cell = VALUE #( type  = cl_xco_xlsx_file=>gc_type-number
                       value = iv_value ).
  ENDMETHOD.

  METHOD text.
    rs_cell = VALUE #( type  = cl_xco_xlsx_file=>gc_type-string
                       value = iv_value ).
  ENDMETHOD.
ENDCLASS.
