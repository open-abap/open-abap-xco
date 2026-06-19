INTERFACE if_xco_ao_class PUBLIC.
  METHODS set_api_state
    IMPORTING
      io_change_scenario TYPE REF TO object
      io_api_state       TYPE REF TO cl_xco_ars_api_state.
ENDINTERFACE.
