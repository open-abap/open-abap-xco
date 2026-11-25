CLASS cx_xco_runtime_exception DEFINITION PUBLIC INHERITING FROM CX_NO_CHECK.
  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg.

    METHODS:
      constructor
        IMPORTING
          textid   LIKE if_t100_message=>t100key OPTIONAL
          previous LIKE previous OPTIONAL.
ENDCLASS.

CLASS cx_xco_runtime_exception IMPLEMENTATION.
  METHOD constructor.
    super->constructor( previous = previous ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
