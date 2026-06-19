INTERFACE if_xco_database_table_field_ct PUBLIC.
  TYPES: BEGIN OF ts_content,
           key_indicator TYPE abap_bool,
           not_null      TYPE abap_bool,
         END OF ts_content.

  METHODS get
    RETURNING
      VALUE(rs_content) TYPE ts_content.

  METHODS get_type
    RETURNING
      VALUE(ro_type) TYPE REF TO if_xco_ad_field_type.
ENDINTERFACE.
