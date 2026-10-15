" the result of an operation that succeeded without messages
CLASS cl_xco_dp_action_result DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_xlsx_row_operation.
  PUBLIC SECTION.
    INTERFACES if_xco_dp_action_result.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_dp_action_result IMPLEMENTATION.
  METHOD constructor.
    if_xco_dp_action_result~succeeded = abap_true.
  ENDMETHOD.

  METHOD if_xco_news~get_messages.
    rt_messages = if_xco_dp_action_result~messages.
  ENDMETHOD.
ENDCLASS.
