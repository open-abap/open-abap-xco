INTERFACE if_xco_ao_class PUBLIC.
  INTERFACES if_xco_ar_object.

  ALIASES exists FOR if_xco_ar_object~exists.
  ALIASES name FOR if_xco_ar_object~name.

  DATA definition TYPE REF TO if_xco_ao_c_definition READ-ONLY.

  METHODS set_api_state
    IMPORTING
      io_change_scenario TYPE REF TO object
      io_api_state       TYPE REF TO cl_xco_ars_api_state.
ENDINTERFACE.
