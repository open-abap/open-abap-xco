INTERFACE if_xco_cp_gen_tabl_dbt_d_o_put PUBLIC.
  METHODS add_object
    IMPORTING
      iv_name          TYPE csequence
    RETURNING
      VALUE(ro_object) TYPE REF TO if_xco_cp_gen_tabl_dbt_object.
ENDINTERFACE.
