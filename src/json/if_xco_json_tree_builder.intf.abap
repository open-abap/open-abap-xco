INTERFACE if_xco_json_tree_builder PUBLIC.
  METHODS begin_object.

  METHODS end_object.

  METHODS begin_array.

  METHODS end_array.

  METHODS add_member
    IMPORTING
      iv_name TYPE clike.

  METHODS add_string
    IMPORTING
      iv_value TYPE clike.

  METHODS add_number
    IMPORTING
      iv_value TYPE numeric.

  METHODS add_boolean
    IMPORTING
      iv_value TYPE abap_bool.

  METHODS add_null.
ENDINTERFACE.
