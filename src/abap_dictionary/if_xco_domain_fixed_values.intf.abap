INTERFACE if_xco_domain_fixed_values PUBLIC.
  DATA all TYPE REF TO if_xco_domain_fixed_values READ-ONLY.

  METHODS get
    IMPORTING io_read_state    TYPE REF TO object OPTIONAL
    RETURNING VALUE(rt_values) TYPE STANDARD TABLE OF string.
ENDINTERFACE.
