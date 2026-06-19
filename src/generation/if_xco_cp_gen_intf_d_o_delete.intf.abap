INTERFACE if_xco_cp_gen_intf_d_o_delete PUBLIC.
  METHODS add_object
    IMPORTING iv_name                    TYPE csequence
    RETURNING VALUE(ro_delete_operation) TYPE REF TO if_xco_cp_gen_intf_d_o_delete.

  METHODS execute
    RETURNING VALUE(ro_result) TYPE REF TO if_xco_gen_o_put_result.
ENDINTERFACE.
