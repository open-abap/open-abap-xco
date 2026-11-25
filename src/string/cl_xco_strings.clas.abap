CLASS cl_xco_strings DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_strings.

    METHODS constructor
      IMPORTING
        it_value TYPE string_table.
ENDCLASS.

CLASS cl_xco_strings IMPLEMENTATION.
  METHOD constructor.
    if_xco_strings~value = it_value.
  ENDMETHOD.

  METHOD if_xco_text~get_lines.
    ro_lines = me.
  ENDMETHOD.

  METHOD if_xco_news~get_messages.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_string_iterable~get_iterator.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_strings~get.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_strings~from.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_strings~to.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_strings~reorder.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_strings~reverse.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_strings~join.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
