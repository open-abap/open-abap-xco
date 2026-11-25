INTERFACE if_xco_behavior_definition PUBLIC.
  INTERFACES if_xco_ar_object.

  ALIASES exists FOR if_xco_ar_object~exists.
  ALIASES name FOR if_xco_ar_object~name.

  METHODS content
    RETURNING VALUE(ro_content) TYPE REF TO if_xco_bdef_content.
ENDINTERFACE.
