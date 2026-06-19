INTERFACE if_xco_database_table_content PUBLIC.
  TYPES: BEGIN OF ts_content,
           short_description TYPE sxco_ao_short_description,
         END OF ts_content.

  METHODS get
    RETURNING
      VALUE(rs_content) TYPE ts_content.
ENDINTERFACE.
