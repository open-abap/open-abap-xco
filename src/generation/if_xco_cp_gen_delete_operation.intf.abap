INTERFACE if_xco_cp_gen_delete_operation PUBLIC.
  METHODS add_object
    IMPORTING iv_name                    TYPE csequence
    RETURNING VALUE(ro_delete_operation) TYPE REF TO if_xco_cp_gen_delete_operation.

  METHODS execute
    RETURNING VALUE(ro_result) TYPE REF TO if_xco_gen_o_put_result.
ENDINTERFACE.
