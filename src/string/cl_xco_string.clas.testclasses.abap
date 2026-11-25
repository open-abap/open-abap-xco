CLASS ltcl_xco_string DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS c_alphabet TYPE string VALUE `abcdefghijklmnopqrstuvwxyz`.

    METHODS value FOR TESTING.
    METHODS value_from_char FOR TESTING.
    METHODS from FOR TESTING.
    METHODS to FOR TESTING.
    METHODS from_to_chained FOR TESTING.
    METHODS out_of_bounds FOR TESTING.
    METHODS from_to_empty FOR TESTING.
    METHODS upper_and_lower_case FOR TESTING.
    METHODS append_and_prepend FOR TESTING.
    METHODS starts_with FOR TESTING.
    METHODS ends_with FOR TESTING.
    METHODS split FOR TESTING.
    METHODS matches_regex FOR TESTING.
    METHODS grep FOR TESTING.
    METHODS grep_nothing FOR TESTING.
    METHODS text_lines FOR TESTING.
    METHODS string_iterator FOR TESTING.
    METHODS messages FOR TESTING.
    METHODS messages_long_text FOR TESTING.
    METHODS as_xstring FOR TESTING.

    " read through a variable, as the pinned transpiler cannot chain an interface attribute after a call
    METHODS value_of
      IMPORTING
        io_string       TYPE REF TO if_xco_string
      RETURNING
        VALUE(rv_value) TYPE string.

    METHODS values_of
      IMPORTING
        io_strings       TYPE REF TO if_xco_strings
      RETURNING
        VALUE(rt_values) TYPE string_table.
ENDCLASS.

CLASS ltcl_xco_string IMPLEMENTATION.
  METHOD value_of.
    rv_value = io_string->value.
  ENDMETHOD.

  METHOD values_of.
    rt_values = io_strings->value.
  ENDMETHOD.

  METHOD value.
    cl_abap_unit_assert=>assert_equals(
      act = value_of( xco_cp=>string( `Hello world` ) )
      exp = `Hello world` ).
  ENDMETHOD.

  METHOD value_from_char.
    DATA lv_char TYPE c LENGTH 10 VALUE 'ABAP'.

    cl_abap_unit_assert=>assert_equals(
      act = value_of( xco_cp=>string( lv_char ) )
      exp = `ABAP` ).
  ENDMETHOD.

  METHOD from.
    DATA(lo_string) = xco_cp=>string( c_alphabet ).

    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_string->from( 2 ) )
      exp = `bcdefghijklmnopqrstuvwxyz` ).
    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_string->from( -23 ) )
      exp = `defghijklmnopqrstuvwxyz` ).
    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_string->from( -5 ) )
      exp = `vwxyz` ).
  ENDMETHOD.

  METHOD to.
    DATA(lo_string) = xco_cp=>string( c_alphabet ).

    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_string->to( 5 ) )
      exp = `abcde` ).
    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_string->to( -25 ) )
      exp = `ab` ).
  ENDMETHOD.

  METHOD from_to_chained.
    DATA(lo_string) = xco_cp=>string( c_alphabet ).

    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_string->from( 2 )->to( 6 ) )
      exp = `bcdefg` ).
    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_string->to( -10 )->from( 4 ) )
      exp = `defghijklmnopq` ).
  ENDMETHOD.

  METHOD out_of_bounds.
    " the cheat sheet: "Providing a value that is out of bounds means that the first (or the last)
    " character of the string is used by default."
    DATA(lo_string) = xco_cp=>string( c_alphabet ).

    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_string->from( 0 )->to( 100 ) )
      exp = c_alphabet ).
    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_string->from( 100 ) )
      exp = `z` ).
    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_string->to( -100 ) )
      exp = `a` ).
  ENDMETHOD.

  METHOD from_to_empty.
    cl_abap_unit_assert=>assert_initial( value_of( xco_cp=>string( `` )->from( 2 ) ) ).
    cl_abap_unit_assert=>assert_initial( value_of( xco_cp=>string( `` )->to( 2 ) ) ).
  ENDMETHOD.

  METHOD upper_and_lower_case.
    cl_abap_unit_assert=>assert_equals(
      act = value_of( xco_cp=>string( `abap` )->to_upper_case( ) )
      exp = `ABAP` ).
    cl_abap_unit_assert=>assert_equals(
      act = value_of( xco_cp=>string( `HALLO WORLD` )->to_lower_case( ) )
      exp = `hallo world` ).
  ENDMETHOD.

  METHOD append_and_prepend.
    DATA(lo_name) = xco_cp=>string( `Max Mustermann` ).

    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_name->append( `, Some Street 1` ) )
      exp = `Max Mustermann, Some Street 1` ).
    cl_abap_unit_assert=>assert_equals(
      act = value_of( lo_name->prepend( `Mr. ` ) )
      exp = `Mr. Max Mustermann` ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_name->value
      exp = `Max Mustermann` ).
  ENDMETHOD.

  METHOD starts_with.
    DATA(lo_string) = xco_cp=>string( `Max Mustermann` ).

    cl_abap_unit_assert=>assert_true( lo_string->starts_with( `Max` ) ).
    cl_abap_unit_assert=>assert_false( lo_string->starts_with( `John` ) ).
    cl_abap_unit_assert=>assert_false( lo_string->starts_with( `Max Mustermann and more` ) ).
    cl_abap_unit_assert=>assert_true( lo_string->starts_with( `` ) ).
  ENDMETHOD.

  METHOD ends_with.
    DATA(lo_string) = xco_cp=>string( `Max Mustermann` ).

    cl_abap_unit_assert=>assert_true( lo_string->ends_with( `mann` ) ).
    cl_abap_unit_assert=>assert_false( lo_string->ends_with( `Max` ) ).
    cl_abap_unit_assert=>assert_false( lo_string->ends_with( `Dr. Max Mustermann` ) ).
    cl_abap_unit_assert=>assert_true( lo_string->ends_with( `` ) ).
  ENDMETHOD.

  METHOD split.
    cl_abap_unit_assert=>assert_equals(
      act = values_of( xco_cp=>string( `Hello.World.ABAP` )->split( `.` ) )
      exp = VALUE string_table( ( `Hello` ) ( `World` ) ( `ABAP` ) ) ).
  ENDMETHOD.

  METHOD matches_regex.
    cl_abap_unit_assert=>assert_true( xco_cp=>string( ` 1` )->matches( `\s\d` ) ).
    cl_abap_unit_assert=>assert_false( xco_cp=>string( ` X` )->matches( `\s\d` ) ).
    cl_abap_unit_assert=>assert_false( xco_cp=>string( ` 12` )->matches( `\s\d` ) ).
  ENDMETHOD.

  METHOD grep.
    cl_abap_unit_assert=>assert_equals(
      act = values_of( xco_cp=>string( `abc123def456` )->grep( `\d+` ) )
      exp = VALUE string_table( ( `123` ) ( `456` ) ) ).
  ENDMETHOD.

  METHOD grep_nothing.
    cl_abap_unit_assert=>assert_initial( values_of( xco_cp=>string( `abcdef` )->grep( `\d+` ) ) ).
  ENDMETHOD.

  METHOD text_lines.
    cl_abap_unit_assert=>assert_equals(
      act = values_of( xco_cp=>string( `Hello world` )->if_xco_text~get_lines( ) )
      exp = VALUE string_table( ( `Hello world` ) ) ).
  ENDMETHOD.

  METHOD string_iterator.
    DATA lt_values TYPE string_table.

    DATA(lo_iterator) = xco_cp=>string( `Hello world` )->if_xco_string_iterable~get_iterator( ).
    WHILE lo_iterator->has_next( ) = abap_true.
      lo_iterator->next( ).
      APPEND value_of( lo_iterator->current_string ) TO lt_values.
    ENDWHILE.

    cl_abap_unit_assert=>assert_equals(
      act = lt_values
      exp = VALUE string_table( ( `Hello world` ) ) ).
  ENDMETHOD.

  METHOD messages.
    DATA(lt_messages) = xco_cp=>string( `Hello world` )->if_xco_news~get_messages( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_messages )
      exp = 1 ).
    DATA(lo_message) = lt_messages[ 1 ].
    cl_abap_unit_assert=>assert_equals(
      act = lo_message->get_text( )
      exp = `Hello world` ).
  ENDMETHOD.

  METHOD messages_long_text.
    " the blanks at the offsets 49 and 50 sit at the border of the first two message variables,
    " the blank at offset 49 moves to the second one, so 199 characters fit into the message
    DATA(lv_text) = repeat( val = `a`
                            occ = 49 ) && `  b`.
    lv_text = lv_text && repeat( val = `c`
                                 occ = 200 ).

    DATA(lt_messages) = xco_cp=>string( lv_text )->if_xco_news~get_messages( ).

    DATA(lo_message) = lt_messages[ 1 ].
    cl_abap_unit_assert=>assert_equals(
      act = lo_message->get_text( )
      exp = substring( val = lv_text
                       len = 199 ) ).
  ENDMETHOD.

  METHOD as_xstring.
    DATA(lo_xstring) = xco_cp=>string( `Some string` )->as_xstring( xco_cp_character=>code_page->utf_8 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_xstring->value
      exp = CONV xstring( '536F6D6520737472696E67' ) ).
  ENDMETHOD.
ENDCLASS.
