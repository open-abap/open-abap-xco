INTERFACE if_xco_ar_object PUBLIC.

  TYPES list TYPE STANDARD TABLE OF REF TO if_xco_ar_object WITH DEFAULT KEY.
  TYPES tv_namespace TYPE c LENGTH 10.

  DATA type TYPE REF TO if_xco_ar_object_type READ-ONLY.
  DATA name TYPE sxco_ar_object_name READ-ONLY.

  METHODS:
    exists
      IMPORTING
        io_origin        TYPE string OPTIONAL
      RETURNING
        VALUE(rv_exists) TYPE abap_bool,
    get_namespace
      RETURNING
        VALUE(rv_namespace) TYPE tv_namespace,
    get_package
      RETURNING
        VALUE(ro_package) TYPE REF TO if_xco_package,
    get_original_language
      RETURNING
        VALUE(ro_original_language) TYPE REF TO if_xco_language.

  METHODS get_state
    IMPORTING io_read_state   TYPE REF TO object OPTIONAL
    RETURNING VALUE(ro_state) TYPE REF TO object.

ENDINTERFACE.
