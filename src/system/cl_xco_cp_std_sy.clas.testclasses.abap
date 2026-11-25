CLASS ltcl_xco_cp_std_sy DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS message FOR TESTING.
    METHODS language FOR TESTING.
    METHODS date FOR TESTING.
    METHODS time FOR TESTING.
ENDCLASS.

CLASS ltcl_xco_cp_std_sy IMPLEMENTATION.
  METHOD message.
    MESSAGE e001(00) WITH 'h' 'e' 'l' 'lo' INTO DATA(lv_dummy).
    DATA(lv_xco_message) = xco_cp=>sy->message( ).

    cl_abap_unit_assert=>assert_not_initial( lv_xco_message->value ).
  ENDMETHOD.

  METHOD language.
    DATA(lo_language) = xco_cp=>sy->language( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_language->value
      exp = sy-langu ).
  ENDMETHOD.

  METHOD date.
    " the date may change between the time stamps, so either date is right
    DATA lv_before TYPE tzntstmps.
    DATA lv_after TYPE tzntstmps.

    GET TIME STAMP FIELD lv_before.
    DATA(lv_date) = xco_cp_time=>format->abap->from_date( xco_cp=>sy->date( xco_cp_time=>time_zone->utc ) ).
    GET TIME STAMP FIELD lv_after.

    DATA(lv_date_before) = CONV string( xco_cp_time=>time_zone->utc->get_date( lv_before ) ).
    DATA(lv_date_after) = CONV string( xco_cp_time=>time_zone->utc->get_date( lv_after ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( lv_date = lv_date_before OR lv_date = lv_date_after ) ).
  ENDMETHOD.

  METHOD time.
    " the time lies between the time stamps, or is one of them if midnight passes in between
    DATA lv_before TYPE tzntstmps.
    DATA lv_after TYPE tzntstmps.

    GET TIME STAMP FIELD lv_before.
    DATA(lv_time) = xco_cp_time=>format->abap->from_time( xco_cp=>sy->time( xco_cp_time=>time_zone->utc ) ).
    GET TIME STAMP FIELD lv_after.

    DATA(lv_time_before) = CONV string( xco_cp_time=>time_zone->utc->get_time( lv_before ) ).
    DATA(lv_time_after) = CONV string( xco_cp_time=>time_zone->utc->get_time( lv_after ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( lv_time = lv_time_before OR lv_time = lv_time_after
                                               OR ( lv_time >= lv_time_before AND lv_time <= lv_time_after ) ) ).
  ENDMETHOD.
ENDCLASS.
