INTERFACE if_xco_cp_tr_filter_factory PUBLIC.
  METHODS status IMPORTING io_status TYPE REF TO cl_xco_transport_status RETURNING VALUE(ro_filter) TYPE REF TO object.
  METHODS owner IMPORTING io_constraint TYPE REF TO object RETURNING VALUE(ro_filter) TYPE REF TO object.
  METHODS request_type IMPORTING io_type TYPE REF TO object RETURNING VALUE(ro_filter) TYPE REF TO object.
  METHODS request_target IMPORTING io_constraint TYPE REF TO object RETURNING VALUE(ro_filter) TYPE REF TO object.
ENDINTERFACE.