INTERFACE if_xco_cds_entity PUBLIC.

  INTERFACES:
    if_xco_ar_object,
    if_xco_cds_ann_target,
    if_xco_printable.

  DATA fields TYPE REF TO if_xco_cds_fields_factory READ-ONLY.

  METHODS get_api_state
    IMPORTING
      io_release_contract TYPE REF TO cl_xco_ars_release_contract
    RETURNING
      VALUE(ro_api_state) TYPE REF TO cl_xco_ars_api_state.

ENDINTERFACE.