INTERFACE if_xco_ao_interface PUBLIC.
  INTERFACES if_xco_ar_object.

  ALIASES name FOR if_xco_ar_object~name.

  METHODS exists
    RETURNING
      VALUE(rv_exists) TYPE abap_bool.

ENDINTERFACE.