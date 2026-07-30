CLASS ltcl_xco_cp_std_sy DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS message FOR TESTING.
    METHODS language FOR TESTING.
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
ENDCLASS.
