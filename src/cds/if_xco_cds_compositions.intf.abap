INTERFACE if_xco_cds_compositions PUBLIC.
  METHODS get
    RETURNING
      VALUE(rt_compositions) TYPE sxco_t_cds_compositions.
ENDINTERFACE.
