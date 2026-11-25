INTERFACE if_xco_cp_transport PUBLIC.
  DATA value TYPE sxco_transport READ-ONLY.

  METHODS get_type
    RETURNING
      VALUE(ro_type) TYPE REF TO cl_xco_tr_type.
ENDINTERFACE.