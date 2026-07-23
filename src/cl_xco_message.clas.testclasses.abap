CLASS ltcl_xco_message DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS get_text FOR TESTING.
    METHODS scaffold_signatures FOR TESTING.
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

  METHOD scaffold_signatures.
    IF 1 = 2.
      DATA(lo_message) = xco_cp=>sy->message( ).
      DATA(lv_uuid) = xco_cp=>uuid( )->as( xco_cp_uuid=>format->c36 )->value.
      DATA(lv_json) = xco_cp_json=>data->from_abap( lv_uuid )->to_string( ).
    ENDIF.

    cl_abap_unit_assert=>assert_true( abap_true ).
  ENDMETHOD.
ENDCLASS.
