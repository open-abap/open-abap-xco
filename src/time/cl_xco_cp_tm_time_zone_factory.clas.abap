CLASS cl_xco_cp_tm_time_zone_factory DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_time.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_tm_time_zone_factory.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_tm_time_zone_factory IMPLEMENTATION.
  METHOD constructor.
    if_xco_cp_tm_time_zone_factory~utc = NEW cl_xco_tm_time_zone( 'UTC' ).

    " created in the class constructor of xco_cp_time, which cannot raise an exception, so UTC
    " stands in when the time zone of the user cannot be read
    TRY.
        if_xco_cp_tm_time_zone_factory~user = NEW cl_xco_tm_time_zone( cl_abap_context_info=>get_user_time_zone( ) ).
      CATCH cx_abap_context_info_error.
        if_xco_cp_tm_time_zone_factory~user = if_xco_cp_tm_time_zone_factory~utc.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
