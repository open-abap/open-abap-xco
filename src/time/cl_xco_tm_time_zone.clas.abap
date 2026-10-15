CLASS cl_xco_tm_time_zone DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_tm_time_zone.

    METHODS constructor
      IMPORTING
        iv_value TYPE if_xco_tm_time_zone=>tv_value.
ENDCLASS.

CLASS cl_xco_tm_time_zone IMPLEMENTATION.
  METHOD constructor.
    if_xco_tm_time_zone~value = iv_value.
  ENDMETHOD.

  METHOD if_xco_tm_time_zone~get_date.
    CONVERT TIME STAMP iv_timestamp TIME ZONE if_xco_tm_time_zone~value INTO DATE rv_date.
  ENDMETHOD.

  METHOD if_xco_tm_time_zone~get_time.
    CONVERT TIME STAMP iv_timestamp TIME ZONE if_xco_tm_time_zone~value INTO TIME rv_time.
  ENDMETHOD.
ENDCLASS.
