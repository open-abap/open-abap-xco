CLASS ltcl_xco_message DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS get_text FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_xco_message IMPLEMENTATION.
  METHOD get_text.
    DATA ls_message TYPE symsg.

    ls_message-msgty = 'E'.
    ls_message-msgid = 'ZXCO_TEST'.
    ls_message-msgno = '001'.
    ls_message-msgv1 = 'one'.
    ls_message-msgv2 = 'two'.
    ls_message-msgv3 = 'three'.
    ls_message-msgv4 = 'four'.

    cl_abap_unit_assert=>assert_equals(
      act = xco_cp=>message( ls_message )->get_text( )
      exp = 'E:ZXCO_TEST:001 one two three four' ).
  ENDMETHOD.

ENDCLASS.
