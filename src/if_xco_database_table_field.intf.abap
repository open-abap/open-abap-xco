INTERFACE if_xco_database_table_field PUBLIC.
  DATA name TYPE sxco_ad_field_name READ-ONLY.

  METHODS content
    RETURNING
      VALUE(ro_content) TYPE REF TO if_xco_database_table_field_ct.
ENDINTERFACE.
