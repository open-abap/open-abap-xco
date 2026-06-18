INTERFACE if_xco_cp_service_form PUBLIC.
  METHODS set_alias
    IMPORTING iv_alias          TYPE csequence
    RETURNING VALUE(ro_service) TYPE REF TO if_xco_cp_service_form.
  METHODS add_version
    IMPORTING iv_version        TYPE csequence
    RETURNING VALUE(ro_service) TYPE REF TO if_xco_cp_service_form.
  METHODS set_service_definition
    IMPORTING iv_service_definition TYPE csequence
    RETURNING VALUE(ro_service)     TYPE REF TO if_xco_cp_service_form.
ENDINTERFACE.
