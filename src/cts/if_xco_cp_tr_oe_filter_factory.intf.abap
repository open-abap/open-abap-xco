INTERFACE if_xco_cp_tr_oe_filter_factory PUBLIC.
  METHODS object_name
    IMPORTING
      io_constraint         TYPE REF TO cl_xco_asql_constraint
    RETURNING
      VALUE(ro_object_name) TYPE REF TO if_xco_tr_entry_filter.
ENDINTERFACE.