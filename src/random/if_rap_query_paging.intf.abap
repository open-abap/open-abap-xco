INTERFACE if_rap_query_paging PUBLIC.
  METHODS get_page_size RETURNING VALUE(rv_page_size) TYPE int8.
  METHODS get_offset RETURNING VALUE(rv_offset) TYPE int8.
ENDINTERFACE.
