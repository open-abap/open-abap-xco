CLASS cl_xco_cp_std_cur_api_cll_stck DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_std_cur_api_cll_stck.
ENDCLASS.

CLASS cl_xco_cp_std_cur_api_cll_stck IMPLEMENTATION.
  METHOD if_xco_cp_std_cur_api_cll_stck~full.
    DATA lv_stack TYPE string.

    " the stack of the JavaScript the ABAP is transpiled to, with every frame, not only the first ten
    WRITE '@KERNEL const previousLimit = Error.stackTraceLimit;'.
    WRITE '@KERNEL Error.stackTraceLimit = Infinity;'.
    WRITE '@KERNEL lv_stack.set(new Error().stack || "");'.
    WRITE '@KERNEL Error.stackTraceLimit = previousLimit;'.

    " the innermost frame is this method
    ro_full = cl_xco_cp_call_stack=>from_javascript(
      iv_stack = lv_stack
      iv_skip  = 1 ).
  ENDMETHOD.
ENDCLASS.
