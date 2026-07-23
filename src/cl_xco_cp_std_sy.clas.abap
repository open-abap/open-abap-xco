CLASS cl_xco_cp_std_sy DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_std_sy.
ENDCLASS.

CLASS cl_xco_cp_std_sy IMPLEMENTATION.
  METHOD if_xco_cp_std_sy~message.
    DATA ls_message TYPE symsg.

    ls_message-msgty = sy-msgty.
    ls_message-msgid = sy-msgid.
    ls_message-msgno = sy-msgno.
    ls_message-msgv1 = sy-msgv1.
    ls_message-msgv2 = sy-msgv2.
    ls_message-msgv3 = sy-msgv3.
    ls_message-msgv4 = sy-msgv4.

    ro_message = NEW cl_xco_message( ls_message ).
  ENDMETHOD.

  METHOD if_xco_news~get_messages.
    APPEND if_xco_cp_std_sy~message( ) TO rt_messages.
  ENDMETHOD.
ENDCLASS.
