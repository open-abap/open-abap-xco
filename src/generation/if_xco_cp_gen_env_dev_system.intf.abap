INTERFACE if_xco_cp_gen_env_dev_system PUBLIC.
  TYPES: BEGIN OF ts_for,
           devc TYPE REF TO if_xco_cp_gen_devc_env,
         END OF ts_for.

  DATA for TYPE ts_for READ-ONLY.

  METHODS create_put_operation
    RETURNING
      VALUE(ro_put_operation) TYPE REF TO if_xco_cp_gen_d_o_put.
ENDINTERFACE.
