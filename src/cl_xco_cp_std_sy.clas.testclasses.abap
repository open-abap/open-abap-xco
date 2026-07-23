CLASS ltcl_xco_cp_std_sy DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS message FOR TESTING.
ENDCLASS.

CLASS ltcl_xco_cp_std_sy IMPLEMENTATION.
  METHOD message.
    MESSAGE e001(00) WITH 'hello' INTO DATA(lv_dummy).
    DATA(lv_xco_message) = xco_cp=>sy->message( ).

    cl_abap_unit_assert=>assert_not_initial( lv_xco_message->value ).
  ENDMETHOD.
ENDCLASS.
