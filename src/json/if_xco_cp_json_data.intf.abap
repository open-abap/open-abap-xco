INTERFACE if_xco_cp_json_data PUBLIC.
  METHODS to_string
    RETURNING VALUE(rv_json) TYPE string.
  METHODS traverse
    IMPORTING io_visitor TYPE REF TO if_xco_json_tree_visitor.
ENDINTERFACE.
