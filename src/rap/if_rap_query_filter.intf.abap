INTERFACE if_rap_query_filter PUBLIC.
  TYPES: BEGIN OF ts_range,
           sign   TYPE c LENGTH 1,
           option TYPE c LENGTH 2,
           low    TYPE string,
           high   TYPE string,
         END OF ts_range.
  TYPES tt_range TYPE STANDARD TABLE OF ts_range WITH DEFAULT KEY.
  TYPES: BEGIN OF ts_name_range_pair,
           name  TYPE string,
           range TYPE tt_range,
         END OF ts_name_range_pair.
  TYPES tt_name_range_pairs TYPE STANDARD TABLE OF ts_name_range_pair WITH DEFAULT KEY.

  METHODS get_as_sql_string RETURNING VALUE(rv_sql) TYPE string.
  METHODS get_as_ranges RETURNING VALUE(rt_ranges) TYPE tt_name_range_pairs.
ENDINTERFACE.
