INTERFACE if_xco_domain_fixed_values PUBLIC.
  METHODS get
    RETURNING VALUE(rt_values) TYPE STANDARD TABLE OF string.
ENDINTERFACE.
