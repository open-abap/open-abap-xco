INTERFACE if_xco_iterator PUBLIC.
  METHODS:
    has_next
      RETURNING
        VALUE(rv_has_next) TYPE abap_bool,
    next.
ENDINTERFACE.