INTERFACE if_xco_gen_srvb_s_fo_service PUBLIC.
  METHODS set_alias
    IMPORTING iv_alias          TYPE csequence
    RETURNING VALUE(ro_service) TYPE REF TO if_xco_gen_srvb_s_fo_service.
  METHODS add_version
    IMPORTING iv_version        TYPE csequence
    RETURNING VALUE(ro_service) TYPE REF TO if_xco_gen_srvb_s_fo_service.
  METHODS set_service_definition
    IMPORTING iv_service_definition TYPE csequence
    RETURNING VALUE(ro_service)     TYPE REF TO if_xco_gen_srvb_s_fo_service.
ENDINTERFACE.
