CLASS ltcl_recorder DEFINITION FINAL FOR TESTING.
  PUBLIC SECTION.
    INTERFACES if_xco_json_tree_visitor.

    DATA mt_events TYPE string_table.
ENDCLASS.

CLASS ltcl_recorder IMPLEMENTATION.
  METHOD if_xco_json_tree_visitor~on_start.
    APPEND `on_start` TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~on_end.
    APPEND `on_end` TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~enter_object.
    APPEND `enter_object` TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~leave_object.
    APPEND `leave_object` TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~enter_array.
    APPEND `enter_array` TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~leave_array.
    APPEND `leave_array` TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~visit_member.
    APPEND |member:{ iv_name }| TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~visit_string.
    APPEND |string:{ iv_value }| TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~visit_number.
    APPEND |number:{ iv_value }| TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~visit_boolean.
    APPEND |boolean:{ iv_value }| TO mt_events.
  ENDMETHOD.

  METHOD if_xco_json_tree_visitor~visit_null.
    APPEND `null` TO mt_events.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_json_data_factory DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_item,
        sku TYPE string,
        qty TYPE i,
      END OF ty_item,
      ty_items TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY,
      BEGIN OF ty_order,
        order_id TYPE string,
        amount   TYPE p LENGTH 9 DECIMALS 2,
        urgent   TYPE abap_bool,
        paid     TYPE abap_bool,
        created  TYPE d,
        code     TYPE n LENGTH 4,
        note     TYPE string,
        items    TYPE ty_items,
      END OF ty_order.

    METHODS sample_order
      RETURNING
        VALUE(rs_order) TYPE ty_order.

    METHODS from_string FOR TESTING.
    METHODS from_string_compacts FOR TESTING.
    METHODS from_string_escapes FOR TESTING.
    METHODS from_string_invalid FOR TESTING.
    METHODS from_abap FOR TESTING.
    METHODS from_abap_types FOR TESTING.
    METHODS from_abap_table FOR TESTING.
    METHODS builder FOR TESTING.
    METHODS builder_null FOR TESTING.
    METHODS traverse FOR TESTING.
    METHODS apply_nothing FOR TESTING.
    METHODS write_to_structure FOR TESTING.
    METHODS write_to_table FOR TESTING.
    METHODS write_to_ignores_unknown FOR TESTING.
    METHODS write_to_null FOR TESTING.
    METHODS write_to_round_trip FOR TESTING.
    METHODS write_to_time_and_bytes FOR TESTING.
    METHODS write_to_invalid_values FOR TESTING.
    METHODS from_abap_time_and_bytes FOR TESTING.
    METHODS from_abap_float FOR TESTING.
    METHODS from_string_empty FOR TESTING.
    METHODS from_string_scalar FOR TESTING.
    METHODS builder_misuse FOR TESTING.

    METHODS assert_write_rejected
      IMPORTING
        iv_json TYPE string
        ia_data TYPE REF TO data.

    METHODS assert_builder_rejected
      IMPORTING
        io_builder TYPE REF TO if_xco_cp_json_data_builder
        iv_step    TYPE string.
ENDCLASS.

CLASS ltcl_json_data_factory IMPLEMENTATION.
  METHOD sample_order.
    rs_order-order_id = `ORD-1`.
    rs_order-amount = '199.90'.
    rs_order-urgent = abap_true.
    rs_order-paid = abap_false.
    rs_order-created = '20240229'.
    rs_order-code = '17'.
    APPEND VALUE #( sku = `KB-1` qty = 2 ) TO rs_order-items.
    APPEND VALUE #( sku = `MS-7` qty = 1 ) TO rs_order-items.
  ENDMETHOD.

  METHOD from_string.
    DATA(lo_data) = xco_cp_json=>data->from_string( '{"text":"hello"}' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data->to_string( )
      exp = '{"text":"hello"}' ).
  ENDMETHOD.

  METHOD from_string_compacts.
    DATA(lo_data) = xco_cp_json=>data->from_string( ` { "a" : [ 1 , true , false , null , "x" ] , "b" : { } , "c" : [ ] } ` ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data->to_string( )
      exp = `{"a":[1,true,false,null,"x"],"b":{},"c":[]}` ).
  ENDMETHOD.

  METHOD from_string_escapes.
    DATA(lo_data) = xco_cp_json=>data->from_string( `{"say \"hi\"":"back\\slash \"quoted\"\nnext line"}` ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data->to_string( )
      exp = `{"say \"hi\"":"back\\slash \"quoted\"\nnext line"}` ).
  ENDMETHOD.

  METHOD from_string_invalid.
    TRY.
        xco_cp_json=>data->from_string( `{"a":}` ).
        cl_abap_unit_assert=>fail( 'invalid JSON was accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD from_abap.
    TYPES:
      BEGIN OF ty_data,
        text   TYPE string,
        number TYPE i,
      END OF ty_data.

    DATA(ls_data) = VALUE ty_data( text = 'hello' number = 42 ).
    DATA(lo_data) = xco_cp_json=>data->from_abap( ls_data ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data->to_string( )
      exp = '{"TEXT":"hello","NUMBER":42}' ).
  ENDMETHOD.

  METHOD from_abap_types.
    DATA(lo_data) = xco_cp_json=>data->from_abap( sample_order( ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data->to_string( )
      exp = `{"ORDER_ID":"ORD-1","AMOUNT":199.90,"URGENT":"X","PAID":"","CREATED":"2024-02-29","CODE":"0017",`
         && `"NOTE":"","ITEMS":[{"SKU":"KB-1","QTY":2},{"SKU":"MS-7","QTY":1}]}` ).
  ENDMETHOD.

  METHOD from_abap_table.
    DATA lt_items TYPE ty_items.

    lt_items = sample_order( )-items.

    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_json=>data->from_abap( lt_items )->to_string( )
      exp = `[{"SKU":"KB-1","QTY":2},{"SKU":"MS-7","QTY":1}]` ).
  ENDMETHOD.

  METHOD builder.
    DATA(lo_builder) = xco_cp_json=>data->builder( ).

    lo_builder->begin_object(
      )->add_member( 'text'
      )->add_string( 'hello'
      )->add_member( 'valid'
      )->add_boolean( abap_true
      )->add_member( 'numbers'
      )->begin_array(
      )->add_number( 1
      )->add_number( 2
      )->end_array(
      )->end_object( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_builder->get_data( )->to_string( )
      exp = '{"text":"hello","valid":true,"numbers":[1,2]}' ).
  ENDMETHOD.

  METHOD builder_null.
    DATA(lo_builder) = xco_cp_json=>data->builder( ).

    lo_builder->begin_object(
      )->add_member( 'nothing'
      )->add_null(
      )->add_member( 'list'
      )->begin_array(
      )->add_null(
      )->add_boolean( abap_false
      )->end_array(
      )->end_object( ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_builder->get_data( )->to_string( )
      exp = '{"nothing":null,"list":[null,false]}' ).
  ENDMETHOD.

  METHOD traverse.
    DATA(lo_recorder) = NEW ltcl_recorder( ).

    xco_cp_json=>data->from_string( `{"a":[1,"x",true,null],"b":{}}` )->traverse( lo_recorder ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_recorder->mt_events
      exp = VALUE string_table(
        ( `on_start` )
        ( `enter_object` )
        ( `member:a` )
        ( `enter_array` )
        ( `number:1` )
        ( `string:x` )
        ( `boolean:X` )
        ( `null` )
        ( `leave_array` )
        ( `member:b` )
        ( `enter_object` )
        ( `leave_object` )
        ( `leave_object` )
        ( `on_end` ) ) ).
  ENDMETHOD.

  METHOD apply_nothing.
    DATA lt_transformations TYPE sxco_t_json_transformations.

    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_json=>data->from_string( `{"ORDER_ID":"1"}` )->apply( lt_transformations )->to_string( )
      exp = `{"ORDER_ID":"1"}` ).
  ENDMETHOD.

  METHOD write_to_structure.
    DATA ls_order TYPE ty_order.

    xco_cp_json=>data->from_string(
      `{"ORDER_ID":"ORD-1","AMOUNT":199.9,"URGENT":"X","PAID":"","CREATED":"2024-02-29","CODE":"0017",`
      && `"ITEMS":[{"SKU":"KB-1","QTY":2},{"SKU":"MS-7","QTY":1}]}` )->write_to( REF #( ls_order ) ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_order
      exp = sample_order( ) ).
  ENDMETHOD.

  METHOD write_to_table.
    DATA lt_items TYPE ty_items.

    APPEND VALUE #( sku = `OLD` qty = 9 ) TO lt_items.

    xco_cp_json=>data->from_string( `[{"SKU":"KB-1","QTY":2},{"SKU":"MS-7","QTY":1}]` )->write_to( REF #( lt_items ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_items
      exp = sample_order( )-items ).
  ENDMETHOD.

  METHOD write_to_ignores_unknown.
    DATA ls_order TYPE ty_order.

    xco_cp_json=>data->from_string(
      `{"UNKNOWN":{"A":[1,{"B":2}]},"ORDER_ID":"ORD-1","order_id":"lower case","MORE":[[]],"NOTE":"n"}`
      )->write_to( REF #( ls_order ) ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_order-order_id
      exp = `ORD-1` ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_order-note
      exp = `n` ).
  ENDMETHOD.

  METHOD write_to_null.
    DATA ls_order TYPE ty_order.

    ls_order = sample_order( ).
    ls_order-note = `note`.

    xco_cp_json=>data->from_string( `{"NOTE":null,"AMOUNT":null,"ITEMS":null}` )->write_to( REF #( ls_order ) ).

    cl_abap_unit_assert=>assert_initial( ls_order-note ).
    cl_abap_unit_assert=>assert_initial( ls_order-amount ).
    cl_abap_unit_assert=>assert_initial( ls_order-items ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_order-order_id
      exp = `ORD-1` ).
  ENDMETHOD.

  METHOD write_to_round_trip.
    DATA ls_order TYPE ty_order.

    xco_cp_json=>data->from_abap( sample_order( ) )->write_to( REF #( ls_order ) ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_order
      exp = sample_order( ) ).
  ENDMETHOD.

  METHOD write_to_time_and_bytes.
    TYPES:
      BEGIN OF ty_data,
        time  TYPE t,
        bytes TYPE x LENGTH 2,
        data  TYPE xstring,
      END OF ty_data.
    DATA ls_data TYPE ty_data.

    xco_cp_json=>data->from_string( `{"TIME":"16:09:07","BYTES":"yv4=","DATA":"AP9/gA=="}` )->write_to( REF #( ls_data ) ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_data
      exp = VALUE ty_data( time  = '160907'
                           bytes = 'CAFE'
                           data  = CONV xstring( '00FF7F80' ) ) ).
  ENDMETHOD.

  METHOD assert_write_rejected.
    TRY.
        xco_cp_json=>data->from_string( iv_json )->write_to( ia_data ).
        cl_abap_unit_assert=>fail( |{ iv_json } was written| ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD write_to_invalid_values.
    DATA lv_integer TYPE i.
    DATA lv_bytes TYPE xstring.
    DATA lv_date TYPE d.
    DATA lv_time TYPE t.

    assert_write_rejected( iv_json = `"twelve"`
                           ia_data = REF #( lv_integer ) ).
    assert_write_rejected( iv_json = `"no base64!"`
                           ia_data = REF #( lv_bytes ) ).
    assert_write_rejected( iv_json = `"2024-02-30"`
                           ia_data = REF #( lv_date ) ).
    assert_write_rejected( iv_json = `"tomorrow"`
                           ia_data = REF #( lv_date ) ).
    assert_write_rejected( iv_json = `"24:00:00"`
                           ia_data = REF #( lv_time ) ).
    assert_write_rejected( iv_json = `"noon"`
                           ia_data = REF #( lv_time ) ).
  ENDMETHOD.

  METHOD from_abap_time_and_bytes.
    TYPES:
      BEGIN OF ty_data,
        time  TYPE t,
        bytes TYPE x LENGTH 2,
        data  TYPE xstring,
      END OF ty_data.

    DATA(ls_data) = VALUE ty_data( time  = '160907'
                                   bytes = 'CAFE'
                                   data  = CONV xstring( '00FF7F80' ) ).

    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_json=>data->from_abap( ls_data )->to_string( )
      exp = `{"TIME":"16:09:07","BYTES":"yv4=","DATA":"AP9/gA=="}` ).
  ENDMETHOD.

  METHOD from_abap_float.
    " the digits of a float depend on how the platform renders it, so only its value is checked
    DATA lv_float TYPE f VALUE '1.5'.
    DATA lv_written TYPE f.
    DATA(lo_recorder) = NEW ltcl_recorder( ).

    DATA(lo_data) = xco_cp_json=>data->from_abap( lv_float ).
    lo_data->traverse( lo_recorder ).
    lo_data->write_to( REF #( lv_written ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_recorder->mt_events
      exp = VALUE string_table( ( `on_start` ) ( `number:1.5` ) ( `on_end` ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_written
      exp = lv_float ).
  ENDMETHOD.

  METHOD from_string_empty.
    TRY.
        xco_cp_json=>data->from_string( `` ).
        cl_abap_unit_assert=>fail( 'empty string accepted' ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD from_string_scalar.
    DATA lv_number TYPE i.

    DATA(lo_data) = xco_cp_json=>data->from_string( `42` ).
    lo_data->write_to( REF #( lv_number ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data->to_string( )
      exp = `42` ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_number
      exp = 42 ).
  ENDMETHOD.

  METHOD assert_builder_rejected.
    TRY.
        CASE iv_step.
          WHEN `string`.
            io_builder->add_string( 'x' ).
          WHEN `member`.
            io_builder->add_member( 'x' ).
          WHEN `end_object`.
            io_builder->end_object( ).
          WHEN `end_array`.
            io_builder->end_array( ).
          WHEN `get_data`.
            io_builder->get_data( ).
        ENDCASE.
        cl_abap_unit_assert=>fail( |{ iv_step } accepted| ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD builder_misuse.
    assert_builder_rejected( io_builder = xco_cp_json=>data->builder( )->begin_object( )
                             iv_step    = `string` ).
    assert_builder_rejected( io_builder = xco_cp_json=>data->builder( )->begin_object( )->add_member( 'a' )
                             iv_step    = `member` ).
    assert_builder_rejected( io_builder = xco_cp_json=>data->builder( )->begin_object( )->add_member( 'a' )
                             iv_step    = `end_object` ).
    assert_builder_rejected( io_builder = xco_cp_json=>data->builder( )->begin_array( )
                             iv_step    = `member` ).
    assert_builder_rejected( io_builder = xco_cp_json=>data->builder( )->begin_array( )
                             iv_step    = `end_object` ).
    assert_builder_rejected( io_builder = xco_cp_json=>data->builder( )
                             iv_step    = `end_object` ).
    assert_builder_rejected( io_builder = xco_cp_json=>data->builder( )->add_null( )
                             iv_step    = `string` ).
    assert_builder_rejected( io_builder = xco_cp_json=>data->builder( )->begin_object( )->add_member( 'a' )->begin_array( )
                             iv_step    = `end_object` ).
    assert_builder_rejected( io_builder = xco_cp_json=>data->builder( )->begin_array( )->begin_object( )
                             iv_step    = `get_data` ).
  ENDMETHOD.
ENDCLASS.
