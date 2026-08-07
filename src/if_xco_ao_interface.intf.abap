INTERFACE if_xco_ao_interface PUBLIC.
  INTERFACES if_xco_ar_object.

  ALIASES name FOR if_xco_ar_object~name.

  DATA components TYPE REF TO if_xco_intf_components_factory READ-ONLY.

  METHODS exists
    RETURNING
      VALUE(rv_exists) TYPE abap_bool.

ENDINTERFACE.