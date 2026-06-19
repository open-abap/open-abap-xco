INTERFACE if_xco_cp_ar_object_name PUBLIC.
  METHODS get_filter
    IMPORTING io_constraint    TYPE REF TO object
    RETURNING VALUE(ro_filter) TYPE REF TO if_xco_ar_filter.
ENDINTERFACE.
