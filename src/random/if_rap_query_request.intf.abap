INTERFACE if_rap_query_request PUBLIC.
  METHODS get_paging RETURNING VALUE(ro_paging) TYPE REF TO if_rap_query_paging.
  METHODS get_requested_elements RETURNING VALUE(rt_elements) TYPE string_table.
  METHODS get_sort_elements RETURNING VALUE(rt_sort) TYPE string_table.
  METHODS get_filter RETURNING VALUE(ro_filter) TYPE REF TO if_rap_query_filter.
ENDINTERFACE.
