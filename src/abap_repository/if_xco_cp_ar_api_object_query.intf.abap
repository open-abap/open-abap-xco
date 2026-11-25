INTERFACE if_xco_cp_ar_api_object_query PUBLIC.
  METHODS in
    IMPORTING
      io_repository   TYPE REF TO object
    RETURNING
      VALUE(ro_query) TYPE REF TO if_xco_cp_ar_api_object_query.

  METHODS get
    RETURNING
      VALUE(rt_objects) TYPE if_xco_ar_object=>list.
ENDINTERFACE.
