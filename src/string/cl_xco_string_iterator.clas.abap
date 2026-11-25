CLASS cl_xco_string_iterator DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_string_iterator.

    METHODS constructor
      IMPORTING
        it_strings TYPE string_table.

  PRIVATE SECTION.
    DATA mt_strings TYPE string_table.
    DATA mv_index TYPE i.
ENDCLASS.

CLASS cl_xco_string_iterator IMPLEMENTATION.
  METHOD constructor.
    mt_strings = it_strings.
  ENDMETHOD.

  METHOD if_xco_iterator~has_next.
    rv_has_next = xsdbool( lines( mt_strings ) > mv_index ).
  ENDMETHOD.

  METHOD if_xco_iterator~next.
    mv_index = mv_index + 1.
    if_xco_string_iterator~current_string = xco_cp=>string( mt_strings[ mv_index ] ).
  ENDMETHOD.
ENDCLASS.
