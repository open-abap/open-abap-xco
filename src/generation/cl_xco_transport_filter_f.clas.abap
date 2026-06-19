CLASS cl_xco_transport_filter_f DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS status IMPORTING io_status TYPE REF TO cl_xco_transport_status RETURNING VALUE(ro_filter) TYPE REF TO object.
    METHODS owner IMPORTING io_constraint TYPE REF TO object RETURNING VALUE(ro_filter) TYPE REF TO object.
    METHODS request_type IMPORTING io_type TYPE REF TO object RETURNING VALUE(ro_filter) TYPE REF TO object.
    METHODS request_target IMPORTING io_constraint TYPE REF TO object RETURNING VALUE(ro_filter) TYPE REF TO object.
ENDCLASS.

CLASS cl_xco_transport_filter_f IMPLEMENTATION.
  METHOD status.
    CLEAR ro_filter.
  ENDMETHOD.

  METHOD owner.
    CLEAR ro_filter.
  ENDMETHOD.

  METHOD request_type.
    CLEAR ro_filter.
  ENDMETHOD.

  METHOD request_target.
    CLEAR ro_filter.
  ENDMETHOD.
ENDCLASS.
