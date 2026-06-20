INTERFACE if_rap_query_response PUBLIC.
  METHODS set_total_number_of_records IMPORTING iv_total_number_of_records TYPE numeric.
  METHODS set_data IMPORTING it_data TYPE ANY TABLE.
ENDINTERFACE.
