INTERFACE if_xco_cp_gen_tabl_dbt_object PUBLIC.
  METHODS set_package
    IMPORTING
      iv_package       TYPE csequence
    RETURNING
      VALUE(ro_object) TYPE REF TO if_xco_cp_gen_tabl_dbt_object.
  METHODS create_form_specification
    RETURNING
      VALUE(ro_form) TYPE REF TO if_xco_cp_gen_tabl_dbt_s_form.
ENDINTERFACE.
