INTERFACE if_xco_dbt_content PUBLIC.

  TYPES: BEGIN OF ts_content,
           short_description TYPE sxco_ao_short_description,
           delivery_class    TYPE REF TO cl_xco_dbt_delivery_class,
         END OF ts_content.

  METHODS get
    RETURNING
      VALUE(rs_content) TYPE ts_content.
  METHODS get_enhancement_category
    RETURNING VALUE(ro_enhancement_category) TYPE REF TO cl_xco_dbt_data_maintenance.
  METHODS get_delivery_class
    RETURNING VALUE(ro_delivery_class) TYPE REF TO cl_xco_dbt_delivery_class.
  METHODS get_includes
    RETURNING VALUE(rt_includes) TYPE sxco_t_tab_include.
ENDINTERFACE.
