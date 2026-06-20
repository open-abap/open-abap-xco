INTERFACE if_xco_json_tree_visitor PUBLIC.
  METHODS on_start.
  METHODS on_end.
  METHODS enter_object.
  METHODS leave_object.
  METHODS enter_array.
  METHODS leave_array.
  METHODS visit_member IMPORTING iv_name TYPE string.
  METHODS visit_string IMPORTING iv_value TYPE string.
  METHODS visit_number IMPORTING iv_value TYPE string.
  METHODS visit_boolean IMPORTING iv_value TYPE abap_bool.
ENDINTERFACE.
