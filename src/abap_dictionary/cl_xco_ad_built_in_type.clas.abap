CLASS cl_xco_ad_built_in_type DEFINITION PUBLIC.
  PUBLIC SECTION.
    TYPES tv_type TYPE c LENGTH 30.
    TYPES tv_length TYPE i.
    TYPES tv_decimals TYPE i.

    DATA type TYPE tv_type READ-ONLY.
    DATA length TYPE tv_length READ-ONLY.
    DATA decimals TYPE tv_decimals READ-ONLY.

    METHODS constructor
      IMPORTING
        iv_type     TYPE csequence
        iv_length   TYPE i
        iv_decimals TYPE i.
ENDCLASS.

CLASS cl_xco_ad_built_in_type IMPLEMENTATION.
  METHOD constructor.
    type = iv_type.
    length = iv_length.
    decimals = iv_decimals.
  ENDMETHOD.
ENDCLASS.
