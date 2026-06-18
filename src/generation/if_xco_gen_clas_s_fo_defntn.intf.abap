INTERFACE if_xco_gen_clas_s_fo_defntn PUBLIC.
  TYPES: BEGIN OF ts_section,
           public TYPE REF TO if_xco_gen_clas_s_fo_d_section,
         END OF ts_section.

  DATA section TYPE ts_section READ-ONLY.

  METHODS add_interface
    IMPORTING iv_interface         TYPE csequence
    RETURNING VALUE(ro_definition) TYPE REF TO if_xco_gen_clas_s_fo_defntn.
ENDINTERFACE.
