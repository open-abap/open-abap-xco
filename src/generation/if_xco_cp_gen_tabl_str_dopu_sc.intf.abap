INTERFACE if_xco_cp_gen_tabl_str_dopu_sc PUBLIC.
  METHODS add_object
    IMPORTING iv_name          TYPE csequence
    RETURNING VALUE(ro_object) TYPE REF TO if_xco_cp_gen_tabl_str_d_o_p_o.
  METHODS create_delete_operation
    RETURNING VALUE(ro_delete_operation) TYPE REF TO if_xco_cp_gen_intf_d_o_delete.
ENDINTERFACE.
