INTERFACE if_xco_dbt_fields PUBLIC.
  METHODS get_names
    RETURNING
      VALUE(rt_names) TYPE sxco_t_ad_field_names.
ENDINTERFACE.