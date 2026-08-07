INTERFACE if_xco_intf_c_methods PUBLIC.
  METHODS get
    RETURNING
      VALUE(rt_methods) TYPE sxco_t_intf_c_methods.
ENDINTERFACE.