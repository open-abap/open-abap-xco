INTERFACE if_xco_cds_fields PUBLIC.

  METHODS get
    RETURNING
      VALUE(rt_fields) TYPE sxco_t_cds_fields.

ENDINTERFACE.