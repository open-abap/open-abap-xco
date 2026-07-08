INTERFACE if_xco_ad_data_element PUBLIC.
  INTERFACES if_xco_ar_object.

  ALIASES exists FOR if_xco_ar_object~exists.
  ALIASES name FOR if_xco_ar_object~name.

  METHODS content
    RETURNING VALUE(ro_content) TYPE REF TO if_xco_dtel_content.
ENDINTERFACE.
