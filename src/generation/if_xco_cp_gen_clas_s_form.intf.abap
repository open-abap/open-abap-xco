INTERFACE if_xco_cp_gen_clas_s_form PUBLIC.
  DATA definition TYPE REF TO if_xco_cp_clas_definition READ-ONLY.
  DATA implementation TYPE REF TO if_xco_cp_clas_implementation READ-ONLY.
  DATA own TYPE REF TO if_xco_cp_clas_own READ-ONLY.

  METHODS set_short_description
    IMPORTING iv_short_description TYPE csequence
    RETURNING VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_clas_s_form.
ENDINTERFACE.
