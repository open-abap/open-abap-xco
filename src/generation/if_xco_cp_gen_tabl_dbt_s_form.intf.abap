INTERFACE if_xco_cp_gen_tabl_dbt_s_form PUBLIC.
  TYPES tv_short_description TYPE c LENGTH 60.

  METHODS set_short_description
    IMPORTING
      iv_short_description TYPE tv_short_description
    RETURNING
      VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_tabl_dbt_s_form.
  METHODS set_data_maintenance
    IMPORTING
      iv_data_maintenance TYPE csequence
    RETURNING
      VALUE(ro_form)      TYPE REF TO if_xco_cp_gen_tabl_dbt_s_form.
  METHODS set_delivery_class
    IMPORTING
      iv_delivery_class TYPE csequence
    RETURNING
      VALUE(ro_form)    TYPE REF TO if_xco_cp_gen_tabl_dbt_s_form.
  METHODS add_field
    IMPORTING
      iv_field_name   TYPE csequence
    RETURNING
      VALUE(ro_field) TYPE REF TO if_xco_gen_tabl_dbt_s_fo_field.
ENDINTERFACE.
