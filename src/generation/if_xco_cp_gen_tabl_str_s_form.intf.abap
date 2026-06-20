INTERFACE if_xco_cp_gen_tabl_str_s_form PUBLIC.
  METHODS set_short_description
    IMPORTING iv_short_description TYPE csequence
    RETURNING VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_tabl_str_s_form.
  METHODS add_component
    IMPORTING iv_name             TYPE csequence
    RETURNING VALUE(ro_component) TYPE REF TO if_xco_gen_tabl_dbt_s_fo_field.
  METHODS add_include
    RETURNING VALUE(ro_include) TYPE REF TO if_xco_gen_tabl_include.
  METHODS set_enhancement_category
    IMPORTING io_category    TYPE REF TO object
    RETURNING VALUE(ro_form) TYPE REF TO if_xco_cp_gen_tabl_str_s_form.
ENDINTERFACE.
