INTERFACE if_xco_gen_ddlx_s_fo_field PUBLIC.
  METHODS add_annotation
    IMPORTING iv_name              TYPE csequence
    RETURNING VALUE(ro_annotation) TYPE REF TO if_xco_gen_cds_s_fo_annotation.
ENDINTERFACE.
