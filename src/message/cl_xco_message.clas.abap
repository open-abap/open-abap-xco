CLASS cl_xco_message DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_message.

    METHODS constructor
      IMPORTING
        is_message TYPE symsg.
ENDCLASS.

CLASS cl_xco_message IMPLEMENTATION.
  METHOD constructor.
    if_xco_message~value = is_message.
  ENDMETHOD.

  METHOD if_xco_message~get_text.
    MESSAGE ID if_xco_message~value-msgid
      TYPE if_xco_message~value-msgty
      NUMBER if_xco_message~value-msgno
      WITH if_xco_message~value-msgv1
           if_xco_message~value-msgv2
           if_xco_message~value-msgv3
           if_xco_message~value-msgv4
      INTO rv_text.
  ENDMETHOD.

  METHOD if_xco_message~get_type.
    CLEAR ro_type.
  ENDMETHOD.

  METHOD if_xco_message~overwrite.
    DATA ls_message TYPE symsg.

    ls_message = if_xco_message~value.
    IF iv_msgty IS SUPPLIED.
      ls_message-msgty = iv_msgty.
    ENDIF.
    IF iv_msgid IS SUPPLIED.
      ls_message-msgid = iv_msgid.
    ENDIF.
    IF iv_msgno IS SUPPLIED.
      ls_message-msgno = iv_msgno.
    ENDIF.
    IF iv_msgv1 IS SUPPLIED.
      ls_message-msgv1 = iv_msgv1.
    ENDIF.
    IF iv_msgv2 IS SUPPLIED.
      ls_message-msgv2 = iv_msgv2.
    ENDIF.
    IF iv_msgv3 IS SUPPLIED.
      ls_message-msgv3 = iv_msgv3.
    ENDIF.
    IF iv_msgv4 IS SUPPLIED.
      ls_message-msgv4 = iv_msgv4.
    ENDIF.

    ro_message = NEW cl_xco_message( ls_message ).
  ENDMETHOD.

  METHOD if_xco_message~place_string.
    DATA ls_message TYPE symsg.

    ls_message = if_xco_message~value.
    IF iv_msgv1 = abap_true.
      ls_message-msgv1 = iv_string.
    ENDIF.
    IF iv_msgv2 = abap_true.
      ls_message-msgv2 = iv_string.
    ENDIF.
    IF iv_msgv3 = abap_true.
      ls_message-msgv3 = iv_string.
    ENDIF.
    IF iv_msgv4 = abap_true.
      ls_message-msgv4 = iv_string.
    ENDIF.

    ro_message = NEW cl_xco_message( ls_message ).
  ENDMETHOD.

  METHOD if_xco_message~write_to_t100_dyn_msg.
    io_t100_dyn_msg->if_t100_message~t100key-msgid = if_xco_message~value-msgid.
    io_t100_dyn_msg->if_t100_message~t100key-msgno = if_xco_message~value-msgno.
    io_t100_dyn_msg->msgty = if_xco_message~value-msgty.
    io_t100_dyn_msg->msgv1 = if_xco_message~value-msgv1.
    io_t100_dyn_msg->msgv2 = if_xco_message~value-msgv2.
    io_t100_dyn_msg->msgv3 = if_xco_message~value-msgv3.
    io_t100_dyn_msg->msgv4 = if_xco_message~value-msgv4.
  ENDMETHOD.

  METHOD if_xco_news~get_messages.
    APPEND me TO rt_messages.
  ENDMETHOD.
ENDCLASS.
