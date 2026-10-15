INTERFACE if_xco_json_tree_visitor PUBLIC.
  METHODS on_start DEFAULT IGNORE.

  METHODS on_end DEFAULT IGNORE.

  METHODS enter_object DEFAULT IGNORE.

  METHODS leave_object DEFAULT IGNORE.

  METHODS enter_array DEFAULT IGNORE.

  METHODS leave_array DEFAULT IGNORE.

  METHODS visit_member DEFAULT IGNORE
    IMPORTING
      iv_name TYPE string.

  METHODS visit_string DEFAULT IGNORE
    IMPORTING
      iv_value TYPE string.

  METHODS visit_number DEFAULT IGNORE
    IMPORTING
      iv_value TYPE numeric.

  METHODS visit_boolean DEFAULT IGNORE
    IMPORTING
      iv_value TYPE abap_bool.

  METHODS visit_null DEFAULT IGNORE.
ENDINTERFACE.
