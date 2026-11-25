INTERFACE if_xco_ad_structure_comp_ct PUBLIC.
  TYPES: BEGIN OF ts_currency_quantity,
           reference_field TYPE sxco_ad_field_name,
         END OF ts_currency_quantity.
  TYPES: BEGIN OF ts_content,
           type              TYPE REF TO if_xco_ad_field_type,
           currency_quantity TYPE ts_currency_quantity,
         END OF ts_content.

  METHODS get
    RETURNING
      VALUE(rs_content) TYPE ts_content.

  METHODS get_type
    RETURNING
      VALUE(ro_type) TYPE REF TO if_xco_ad_field_type.
ENDINTERFACE.
