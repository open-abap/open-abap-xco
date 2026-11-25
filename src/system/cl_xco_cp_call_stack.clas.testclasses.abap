CLASS ltcl_call_stack DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS class_methods FOR TESTING.
    METHODS program FOR TESTING.
    METHODS function_group FOR TESTING.
    METHODS namespaces FOR TESTING.
    METHODS system_frames FOR TESTING.
    METHODS not_abap_left_out FOR TESTING.
    METHODS empty_stack FOR TESTING.
    METHODS skip_innermost FOR TESTING.
    METHODS source_maps FOR TESTING.

    METHODS lines_of
      IMPORTING
        iv_stack        TYPE string
        iv_skip         TYPE i DEFAULT 0
      RETURNING
        VALUE(rt_lines) TYPE string_table.
ENDCLASS.

CLASS ltcl_call_stack IMPLEMENTATION.
  METHOD lines_of.
    DATA lo_call_stack TYPE REF TO if_xco_cp_call_stack.

    lo_call_stack = cl_xco_cp_call_stack=>from_javascript(
      iv_stack = iv_stack
      iv_skip  = iv_skip ).
    DATA(lo_lines) = lo_call_stack->as_text( xco_cp_call_stack=>format->adt( ) )->get_lines( ).
    rt_lines = lo_lines->value.
  ENDMETHOD.

  METHOD class_methods.
    DATA(lv_stack) = |Error\n| &&
      |    at zcl_order.cancel (file:///out/zcl_order.clas.mjs:33:42)\n| &&
      |    at #check (file:///out/zcl_order.clas.mjs:46:42)\n| &&
      |    at async zcl_order.zif_order$cancel (file:///out/zcl_order.clas.mjs:50:5)\n| &&
      |    at zcl_order.constructor_ (file:///out/zcl_order.clas.mjs:26:42)\n| &&
      |    at lcl_helper.go (file:///out/zcl_order.clas.locals.mjs:25:42)\n| &&
      |    at async #when_cancelled_then_logged (file:///out/zcl_order.clas.testclasses.mjs:27:5)|.

    cl_abap_unit_assert=>assert_equals(
      act = lines_of( lv_stack )
      exp = VALUE string_table(
        ( `ZCL_ORDER    cancel [method]` )
        ( `ZCL_ORDER    check [method]` )
        ( `ZCL_ORDER    zif_order~cancel [method]` )
        ( `ZCL_ORDER    constructor [method]` )
        ( `ZCL_ORDER    go [method]` )
        ( `ZCL_ORDER    when_cancelled_then_logged [method]` ) ) ).
  ENDMETHOD.

  METHOD program.
    DATA(lv_stack) = |Error\n| &&
      |    at lcl_app.go (file:///out/zreport.prog.mjs:27:42)\n| &&
      |    at run_form (file:///out/zreport.prog.mjs:33:52)\n| &&
      |    at async file:///out/zreport.prog.mjs:37:1|.

    cl_abap_unit_assert=>assert_equals(
      act = lines_of( lv_stack )
      exp = VALUE string_table(
        ( `ZREPORT    go [method]` )
        ( `ZREPORT    run_form [form]` )
        ( `ZREPORT    start-of-selection [event]` ) ) ).
  ENDMETHOD.

  METHOD function_group.
    DATA(lv_stack) = |Error\n| &&
      |    at function_exists (file:///out/openabap.fugr.mjs:120:7)\n| &&
      |    at lcl_buffer.read (file:///out/zorders.fugr.mjs:20:3)\n| &&
      |    at read_buffer (file:///out/zorders.fugr.mjs:10:3)|.

    cl_abap_unit_assert=>assert_equals(
      act = lines_of( lv_stack )
      exp = VALUE string_table(
        ( `SAPLOPENABAP [system]    function_exists [function]` )
        ( `SAPLZORDERS    read [method]` )
        ( `SAPLZORDERS    read_buffer [form]` ) ) ).
  ENDMETHOD.

  METHOD namespaces.
    DATA(lv_stack) = |Error\n| &&
      |    at $ns$cl_order.$ns$if_order$cancel (file:///out/#ns#cl_order.clas.mjs:5:5)\n| &&
      |    at $ns$cl_order.zif_order$$ns$check (file:///out/#ns#cl_order.clas.mjs:9:5)\n| &&
      |    at $ns$read_buffer (file:///out/#ns#orders.fugr.mjs:10:3)|.

    cl_abap_unit_assert=>assert_equals(
      act = lines_of( lv_stack )
      exp = VALUE string_table(
        ( `/NS/CL_ORDER    /ns/if_order~cancel [method]` )
        ( `/NS/CL_ORDER    zif_order~/ns/check [method]` )
        ( `/NS/SAPLORDERS    /ns/read_buffer [form]` ) ) ).
  ENDMETHOD.

  METHOD system_frames.
    DATA(lv_stack) = |Error\n| &&
      |    at cl_abap_unit_assert.fail (file:///out/cl_abap_unit_assert.clas.mjs:5:5)\n| &&
      |    at zcl_order.cancel (file:///out/zcl_order.clas.mjs:33:42)\n| &&
      |    at ycl_order.cancel (file:///out/ycl_order.clas.mjs:33:42)|.

    cl_abap_unit_assert=>assert_equals(
      act = lines_of( lv_stack )
      exp = VALUE string_table(
        ( `CL_ABAP_UNIT_ASSERT [system]    fail [method]` )
        ( `ZCL_ORDER    cancel [method]` )
        ( `YCL_ORDER    cancel [method]` ) ) ).
  ENDMETHOD.

  METHOD not_abap_left_out.
    DATA(lv_stack) = |Error\n| &&
      |    at throwError (/app/node_modules/@abaplint/runtime/build/src/throw_error.js:15:15)\n| &&
      |    at file:///out/zcl_order.clas.mjs:40:7\n| &&
      |    at zcl_order.cancel (file:///out/zcl_order.clas.mjs:33:42)\n| &&
      |    at new zcl_order (file:///out/zcl_order.clas.mjs:20:5)\n| &&
      |    at new Promise (<anonymous>)\n| &&
      |    at async Promise.all (index 0)\n| &&
      |    at process.processTicksAndRejections (node:internal/process/task_queues:95:5)\n| &&
      |    at setup (file:///app/setup.mjs:3:1)\n| &&
      |    at async run (file:///out/index.mjs:36:9)|.

    cl_abap_unit_assert=>assert_equals(
      act = lines_of( lv_stack )
      exp = VALUE string_table( ( `ZCL_ORDER    cancel [method]` ) ) ).
  ENDMETHOD.

  METHOD empty_stack.
    cl_abap_unit_assert=>assert_initial( lines_of( `` ) ).
  ENDMETHOD.

  METHOD skip_innermost.
    DATA(lv_stack) = |Error\n| &&
      |    at cl_xco_cp_std_cur_api_cll_stck.if_xco_cp_std_cur_api_cll_stck$full (file:///out/x.clas.mjs:9:9)\n| &&
      |    at file:///out/index.mjs:1:1\n| &&
      |    at zcl_order.check (file:///out/zcl_order.clas.mjs:46:42)\n| &&
      |    at zcl_order.cancel (file:///out/zcl_order.clas.mjs:33:42)|.

    cl_abap_unit_assert=>assert_equals(
      act = lines_of( iv_stack = lv_stack
                      iv_skip  = 2 )
      exp = VALUE string_table( ( `ZCL_ORDER    cancel [method]` ) ) ).
  ENDMETHOD.

  METHOD source_maps.
    " node --enable-source-maps writes the ABAP files of the source maps instead of the JavaScript files
    DATA(lv_stack) = |Error\n| &&
      |    at zcl_order.cancel (/repo/src/zcl_order.clas.abap:12:5)\n| &&
      |    at lcl_helper.go (C:\\repo\\src\\zcl_order.clas.locals_imp.abap:3:7)|.

    cl_abap_unit_assert=>assert_equals(
      act = lines_of( lv_stack )
      exp = VALUE string_table(
        ( `ZCL_ORDER    cancel [method]` )
        ( `ZCL_ORDER    go [method]` ) ) ).
  ENDMETHOD.
ENDCLASS.
