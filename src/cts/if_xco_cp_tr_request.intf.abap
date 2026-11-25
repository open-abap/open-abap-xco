INTERFACE if_xco_cp_tr_request PUBLIC.
  DATA value TYPE sxco_transport READ-ONLY.
  DATA attributes TYPE REF TO if_xco_cp_tr_request_attrbts_f READ-ONLY.

  METHODS get_request RETURNING VALUE(ro_request) TYPE REF TO if_xco_cp_tr_request.

  METHODS exists RETURNING VALUE(rv_exists) TYPE abap_bool.

  METHODS get_status RETURNING VALUE(ro_status) TYPE REF TO cl_xco_transport_status.

  METHODS get_tasks RETURNING VALUE(rt_tasks) TYPE sxco_t_cp_tr_tasks.

  METHODS properties
    RETURNING
      VALUE(ro_properties) TYPE REF TO if_xco_cp_tr_request_proprties.

  METHODS create_task
    RETURNING
      VALUE(ro_task) TYPE REF TO if_xco_cp_tr_task.
ENDINTERFACE.
