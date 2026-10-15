CLASS cl_xco_xstring DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_xstring.

    METHODS constructor
      IMPORTING
        iv_value TYPE xstring.
ENDCLASS.

CLASS cl_xco_xstring IMPLEMENTATION.
  METHOD constructor.
    if_xco_xstring~value = iv_value.
  ENDMETHOD.

  METHOD if_xco_xstring~as_string.
    ro_string = xco_cp=>string( io_conversion->apply( if_xco_xstring~value ) ).
  ENDMETHOD.
ENDCLASS.
