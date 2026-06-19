INTERFACE if_xco_gen_ddls_s_fo_p_view PUBLIC.
  METHODS set_provider_contract
    IMPORTING io_provider_contract TYPE REF TO object
    RETURNING VALUE(ro_view)       TYPE REF TO if_xco_gen_ddls_s_fo_p_view.
ENDINTERFACE.
