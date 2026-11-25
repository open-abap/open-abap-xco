INTERFACE if_xco_ao_c_method PUBLIC.
  TYPES tv_name TYPE c LENGTH 61.
  METHODS exists
    RETURNING
      VALUE(rv_exists) TYPE abap_bool.
ENDINTERFACE.