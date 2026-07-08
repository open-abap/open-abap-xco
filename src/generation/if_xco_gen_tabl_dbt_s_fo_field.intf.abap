INTERFACE if_xco_gen_tabl_dbt_s_fo_field PUBLIC.
  DATA currency_quantity TYPE REF TO if_xco_gen_tabl_s_fo_curr_quan READ-ONLY.

  METHODS set_key_indicator
    RETURNING
      VALUE(ro_field) TYPE REF TO if_xco_gen_tabl_dbt_s_fo_field.
  METHODS set_not_null
    RETURNING
      VALUE(ro_field) TYPE REF TO if_xco_gen_tabl_dbt_s_fo_field.
  METHODS set_type
    IMPORTING
      io_type         TYPE REF TO if_xco_ad_table_type
    RETURNING
      VALUE(ro_field) TYPE REF TO if_xco_gen_tabl_dbt_s_fo_field.
ENDINTERFACE.
