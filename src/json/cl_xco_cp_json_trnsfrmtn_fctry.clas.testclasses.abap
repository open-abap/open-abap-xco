CLASS ltcl_tree_builder DEFINITION FINAL FOR TESTING.
  PUBLIC SECTION.
    INTERFACES if_xco_json_tree_builder.

    DATA mt_events TYPE string_table.
ENDCLASS.

CLASS ltcl_tree_builder IMPLEMENTATION.
  METHOD if_xco_json_tree_builder~begin_object.
    APPEND `begin_object` TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~end_object.
    APPEND `end_object` TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~begin_array.
    APPEND `begin_array` TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~end_array.
    APPEND `end_array` TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~add_member.
    APPEND |member:{ iv_name }| TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~add_string.
    APPEND |string:{ iv_value }| TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~add_number.
    APPEND |number:{ iv_value }| TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~add_boolean.
    APPEND |boolean:{ iv_value }| TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~add_null.
    APPEND `null` TO mt_events.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_json_transformations DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_item,
        in_stock TYPE abap_bool,
      END OF ty_item,
      ty_items TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY,
      BEGIN OF ty_order,
        order_id  TYPE string,
        is_urgent TYPE abap_bool,
        is_paid   TYPE abap_bool,
        items     TYPE ty_items,
      END OF ty_order.

    METHODS apply
      IMPORTING
        iv_json           TYPE string
        io_transformation TYPE REF TO if_xco_json_transformation
      RETURNING
        VALUE(rv_json)    TYPE string.

    METHODS underscore_to_camel_case FOR TESTING.
    METHODS underscore_to_pascal_case FOR TESTING.
    METHODS camel_case_to_underscore FOR TESTING.
    METHODS pascal_case_to_underscore FOR TESTING.
    METHODS to_underscore_word_boundaries FOR TESTING.
    METHODS unbalanced_events FOR TESTING.
    METHODS boolean_to_abap_bool FOR TESTING.
    METHODS name_replacement FOR TESTING.
    METHODS apply_in_order FOR TESTING.
    METHODS apply_then_write_to FOR TESTING.
    METHODS apply_keeps_original FOR TESTING.
ENDCLASS.

CLASS ltcl_json_transformations IMPLEMENTATION.
  METHOD apply.
    rv_json = xco_cp_json=>data->from_string( iv_json )->apply( VALUE #( ( io_transformation ) ) )->to_string( ).
  ENDMETHOD.

  METHOD underscore_to_camel_case.
    cl_abap_unit_assert=>assert_equals(
      act = apply( iv_json           = `{"ORDER_ID":"ORDER_ID","ITEMS":[{"IN_STOCK":true,"NO":null}],"AMOUNT":1.5}`
                   io_transformation = xco_cp_json=>transformation->underscore_to_camel_case )
      exp = `{"orderId":"ORDER_ID","items":[{"inStock":true,"no":null}],"amount":1.5}` ).
  ENDMETHOD.

  METHOD underscore_to_pascal_case.
    cl_abap_unit_assert=>assert_equals(
      act = apply( iv_json           = `{"ORDER_ID":"x","ITEMS":[{"IN_STOCK":true}]}`
                   io_transformation = xco_cp_json=>transformation->underscore_to_pascal_case )
      exp = `{"OrderId":"x","Items":[{"InStock":true}]}` ).
  ENDMETHOD.

  METHOD camel_case_to_underscore.
    cl_abap_unit_assert=>assert_equals(
      act = apply( iv_json           = `{"orderId":"orderId","items":[{"inStock":false}]}`
                   io_transformation = xco_cp_json=>transformation->camel_case_to_underscore )
      exp = `{"ORDER_ID":"orderId","ITEMS":[{"IN_STOCK":false}]}` ).
  ENDMETHOD.

  METHOD pascal_case_to_underscore.
    cl_abap_unit_assert=>assert_equals(
      act = apply( iv_json           = `{"CarrierId":"DL","CityFrom":"San Francisco","generator":1}`
                   io_transformation = xco_cp_json=>transformation->pascal_case_to_underscore )
      exp = `{"CARRIER_ID":"DL","CITY_FROM":"San Francisco","GENERATOR":1}` ).
  ENDMETHOD.

  METHOD to_underscore_word_boundaries.
    cl_abap_unit_assert=>assert_equals(
      act = apply( iv_json           = `{"ORDER_ID":1,"orderID":2,"item2Name":3,"Id":4,"_x":5}`
                   io_transformation = xco_cp_json=>transformation->camel_case_to_underscore )
      exp = `{"ORDER_ID":1,"ORDER_ID":2,"ITEM2_NAME":3,"ID":4,"_X":5}` ).
  ENDMETHOD.

  METHOD unbalanced_events.
    DATA(lo_tree_builder) = NEW ltcl_tree_builder( ).
    DATA(lo_visitor) = xco_cp_json=>transformation->camel_case_to_underscore->get_visitor( lo_tree_builder ).

    lo_visitor->on_start( ).
    lo_visitor->enter_object( ).
    lo_visitor->visit_member( `orderId` ).
    lo_visitor->leave_array( ).
    lo_visitor->on_end( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_tree_builder->mt_events
      exp = VALUE string_table( ( `begin_object` ) ( `member:ORDER_ID` ) ( `end_array` ) ) ).
  ENDMETHOD.

  METHOD boolean_to_abap_bool.
    cl_abap_unit_assert=>assert_equals(
      act = apply( iv_json           = `{"a":true,"b":false,"c":"true","d":[true]}`
                   io_transformation = xco_cp_json=>transformation->boolean_to_abap_bool )
      exp = `{"a":"X","b":"","c":"true","d":["X"]}` ).
  ENDMETHOD.

  METHOD name_replacement.
    DATA lt_mapping TYPE sxco_t_json_name_mapping.

    APPEND VALUE #( old_name = `id` new_name = `ORDER_ID` ) TO lt_mapping.

    cl_abap_unit_assert=>assert_equals(
      act = apply( iv_json           = `{"id":"id","other":{"id":1}}`
                   io_transformation = xco_cp_json=>transformation->name_replacement( lt_mapping ) )
      exp = `{"ORDER_ID":"id","other":{"ORDER_ID":1}}` ).
  ENDMETHOD.

  METHOD apply_in_order.
    DATA(lo_data) = xco_cp_json=>data->from_string( `{"isUrgent":true}` )->apply( VALUE #(
      ( xco_cp_json=>transformation->camel_case_to_underscore )
      ( xco_cp_json=>transformation->boolean_to_abap_bool )
      ( xco_cp_json=>transformation->underscore_to_pascal_case ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data->to_string( )
      exp = `{"IsUrgent":"X"}` ).
  ENDMETHOD.

  METHOD apply_then_write_to.
    DATA ls_order TYPE ty_order.

    xco_cp_json=>data->from_string( `{"orderId":"4711","isUrgent":true,"isPaid":false,"items":[{"inStock":true}]}`
      )->apply( VALUE #(
        ( xco_cp_json=>transformation->camel_case_to_underscore )
        ( xco_cp_json=>transformation->boolean_to_abap_bool ) )
      )->write_to( REF #( ls_order ) ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_order
      exp = VALUE ty_order( order_id  = `4711`
                            is_urgent = abap_true
                            is_paid   = abap_false
                            items     = VALUE #( ( in_stock = abap_true ) ) ) ).
  ENDMETHOD.

  METHOD apply_keeps_original.
    DATA(lo_data) = xco_cp_json=>data->from_string( `{"orderId":1}` ).

    lo_data->apply( VALUE #( ( xco_cp_json=>transformation->camel_case_to_underscore ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data->to_string( )
      exp = `{"orderId":1}` ).
  ENDMETHOD.
ENDCLASS.
