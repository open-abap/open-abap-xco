INTERFACE if_xco_cp_tr_filter_factory PUBLIC.
  METHODS status IMPORTING io_status TYPE REF TO cl_xco_transport_status RETURNING VALUE(ro_filter) TYPE REF TO object.
  METHODS owner IMPORTING io_constraint TYPE REF TO object RETURNING VALUE(ro_filter) TYPE REF TO object.
  METHODS request_type IMPORTING io_type TYPE REF TO object RETURNING VALUE(ro_filter) TYPE REF TO object.
  METHODS request_target IMPORTING io_constraint TYPE REF TO object RETURNING VALUE(ro_filter) TYPE REF TO object.
  METHODS kind
    IMPORTING
      io_kind        TYPE REF TO cl_xco_tr_kind
    RETURNING
      VALUE(ro_kind) TYPE REF TO if_xco_tr_filter.
  METHODS type
    IMPORTING
      io_type        TYPE REF TO cl_xco_tr_type
    RETURNING
      VALUE(ro_type) TYPE REF TO if_xco_tr_filter.
ENDINTERFACE.