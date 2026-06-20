INTERFACE if_xco_ad_data_element PUBLIC.
  INTERFACES if_xco_ar_object.
  INTERFACES if_xco_ad_built_in_type_rfrnc.

  ALIASES exists FOR if_xco_ar_object~exists.
  ALIASES name FOR if_xco_ar_object~name.

  METHODS content
    RETURNING VALUE(ro_content) TYPE REF TO if_xco_dtel_content.
ENDINTERFACE.
