CLASS cl_xco_string DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_string.

    METHODS constructor
      IMPORTING
        iv_value TYPE string.

  PRIVATE SECTION.
    METHODS position
      IMPORTING
        iv_position        TYPE i
      RETURNING
        VALUE(rv_position) TYPE i.
ENDCLASS.

CLASS cl_xco_string IMPLEMENTATION.
  METHOD constructor.
    if_xco_string~value = iv_value.
  ENDMETHOD.

  METHOD position.
    " 1 is the first character, -1 the last one; a position out of bounds stands for the first or
    " last character, as documented in the XCO section of the SAP ABAP cheat sheet on strings
    DATA(lv_length) = strlen( if_xco_string~value ).

    rv_position = iv_position.
    IF rv_position < 0.
      rv_position = lv_length + rv_position + 1.
    ENDIF.
    rv_position = nmax( val1 = 1
                        val2 = nmin( val1 = rv_position
                                     val2 = lv_length ) ).
  ENDMETHOD.

  METHOD if_xco_news~get_messages.
    " the text goes into the message variables of "&1&2&3&4", 50 characters each, so a message
    " shows at most 200 characters and the rest is cut; as trailing blanks of a variable are
    " lost in the message text, a blank at the end of a part starts the next part instead
    DATA lt_parts TYPE string_table.
    DATA ls_message TYPE symsg.

    DATA(lv_rest) = if_xco_string~value.
    DO 4 TIMES.
      DATA(lv_length) = nmin( val1 = strlen( lv_rest )
                              val2 = 50 ).
      IF strlen( lv_rest ) > lv_length.
        WHILE lv_length > 1 AND substring( val = lv_rest
                                           off = lv_length - 1
                                           len = 1 ) = ` `.
          lv_length = lv_length - 1.
        ENDWHILE.
      ENDIF.
      APPEND substring( val = lv_rest
                        len = lv_length ) TO lt_parts.
      lv_rest = substring( val = lv_rest
                           off = lv_length ).
    ENDDO.

    ls_message-msgty = 'I'.
    ls_message-msgid = '00'.
    ls_message-msgno = '001'.
    ls_message-msgv1 = lt_parts[ 1 ].
    ls_message-msgv2 = lt_parts[ 2 ].
    ls_message-msgv3 = lt_parts[ 3 ].
    ls_message-msgv4 = lt_parts[ 4 ].
    APPEND xco_cp=>message( ls_message ) TO rt_messages.
  ENDMETHOD.

  METHOD if_xco_text~get_lines.
    ro_lines = NEW cl_xco_strings( VALUE #( ( if_xco_string~value ) ) ).
  ENDMETHOD.

  METHOD if_xco_string_iterable~get_iterator.
    ro_iterator = NEW cl_xco_string_iterator( VALUE #( ( if_xco_string~value ) ) ).
  ENDMETHOD.

  METHOD if_xco_string~matches.
    rv_matches = xsdbool( matches( val  = if_xco_string~value
                                   pcre = iv_regular_expression ) ).
  ENDMETHOD.

  METHOD if_xco_string~grep.
    DATA lt_matches TYPE string_table.

    FIND ALL OCCURRENCES OF PCRE iv_regular_expression IN if_xco_string~value RESULTS DATA(lt_results).
    IF sy-subrc = 0.
      LOOP AT lt_results INTO DATA(ls_result).
        APPEND substring( val = if_xco_string~value
                          off = ls_result-offset
                          len = ls_result-length ) TO lt_matches.
      ENDLOOP.
    ENDIF.

    ro_result = NEW cl_xco_strings( lt_matches ).
  ENDMETHOD.

  METHOD if_xco_string~starts_with.
    DATA(lv_length) = strlen( iv_substring ).

    IF strlen( if_xco_string~value ) >= lv_length.
      rv_starts_with = xsdbool( substring( val = if_xco_string~value
                                           len = lv_length ) = iv_substring ).
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_string~ends_with.
    DATA(lv_offset) = strlen( if_xco_string~value ) - strlen( iv_substring ).

    IF lv_offset >= 0.
      rv_ends_with = xsdbool( substring( val = if_xco_string~value
                                         off = lv_offset ) = iv_substring ).
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_string~from.
    IF if_xco_string~value IS INITIAL.
      ro_string = me.
      RETURN.
    ENDIF.

    ro_string = NEW cl_xco_string( substring( val = if_xco_string~value
                                              off = position( iv_position ) - 1 ) ).
  ENDMETHOD.

  METHOD if_xco_string~to.
    IF if_xco_string~value IS INITIAL.
      ro_string = me.
      RETURN.
    ENDIF.

    ro_string = NEW cl_xco_string( substring( val = if_xco_string~value
                                              len = position( iv_position ) ) ).
  ENDMETHOD.

  METHOD if_xco_string~to_upper_case.
    ro_string = NEW cl_xco_string( to_upper( if_xco_string~value ) ).
  ENDMETHOD.

  METHOD if_xco_string~to_lower_case.
    ro_string = NEW cl_xco_string( to_lower( if_xco_string~value ) ).
  ENDMETHOD.

  METHOD if_xco_string~append.
    ro_concatenated_string = NEW cl_xco_string( if_xco_string~value && iv_string ).
  ENDMETHOD.

  METHOD if_xco_string~prepend.
    ro_concatenated_string = NEW cl_xco_string( iv_string && if_xco_string~value ).
  ENDMETHOD.

  METHOD if_xco_string~split.
    SPLIT if_xco_string~value AT iv_delimiter INTO TABLE DATA(lt_parts).
    ro_strings = NEW cl_xco_strings( lt_parts ).
  ENDMETHOD.

  METHOD if_xco_string~as_xstring.
    ro_xstring = xco_cp=>xstring( io_conversion->apply( if_xco_string~value ) ).
  ENDMETHOD.
ENDCLASS.
