INTERFACE if_xco_ad_structure_components PUBLIC.
  DATA all TYPE REF TO if_xco_ad_structure_components READ-ONLY.

  METHODS get
    RETURNING
      VALUE(rt_components) TYPE sxco_t_ad_structure_components.
ENDINTERFACE.
