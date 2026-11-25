INTERFACE if_xco_packages PUBLIC.
  METHODS get
    RETURNING
      VALUE(rt_packages) TYPE sxco_t_packages.
ENDINTERFACE.