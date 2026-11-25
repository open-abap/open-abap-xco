CLASS cl_xco_language DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_language.

    METHODS constructor
      IMPORTING
        iv_value TYPE spras.
ENDCLASS.

CLASS cl_xco_language IMPLEMENTATION.
  METHOD constructor.
    if_xco_language~value = iv_value.
  ENDMETHOD.

  METHOD if_xco_language~get_name.
    CASE if_xco_language~value.
      WHEN 'D'.
        rv_name = 'German'.
      WHEN 'E'.
        rv_name = 'English'.
      WHEN 'F'.
        rv_name = 'French'.
      WHEN 'I'.
        rv_name = 'Italian'.
      WHEN 'J'.
        rv_name = 'Japanese'.
      WHEN 'S'.
        rv_name = 'Spanish'.
      WHEN OTHERS.
        rv_name = if_xco_language~value.
    ENDCASE.
  ENDMETHOD.

  METHOD if_xco_language~get_long_text_description.
    CASE if_xco_language~value.
      WHEN 'D'.
        rv_long_text_description = 'German, Germany'.
      WHEN 'E'.
        rv_long_text_description = 'English, United States'.
      WHEN 'F'.
        rv_long_text_description = 'French, France'.
      WHEN 'I'.
        rv_long_text_description = 'Italian, Italy'.
      WHEN 'J'.
        rv_long_text_description = 'Japanese, Japan'.
      WHEN 'S'.
        rv_long_text_description = 'Spanish, Spain'.
      WHEN OTHERS.
        rv_long_text_description = if_xco_language~value.
    ENDCASE.
  ENDMETHOD.

  METHOD if_xco_printable~get_text.
    ro_text = xco_cp=>string( if_xco_language~get_long_text_description( ) ).
  ENDMETHOD.
ENDCLASS.
