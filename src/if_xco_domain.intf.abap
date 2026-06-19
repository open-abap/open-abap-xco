INTERFACE if_xco_domain PUBLIC.
  INTERFACES if_xco_ar_object.

  ALIASES exists FOR if_xco_ar_object~exists.
  ALIASES name FOR if_xco_ar_object~name.

  DATA fixed_values TYPE REF TO if_xco_domain_fixed_values READ-ONLY.
ENDINTERFACE.
