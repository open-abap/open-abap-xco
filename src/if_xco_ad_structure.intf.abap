INTERFACE if_xco_ad_structure PUBLIC.
  INTERFACES if_xco_ar_object.

  ALIASES exists FOR if_xco_ar_object~exists.
  ALIASES name FOR if_xco_ar_object~name.
  ALIASES get_state FOR if_xco_ar_object~get_state.

  DATA components TYPE REF TO if_xco_ad_structure_components READ-ONLY.
ENDINTERFACE.
