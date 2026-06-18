INTERFACE if_xco_cp_clas_implementation PUBLIC.
  METHODS add_method
    IMPORTING iv_name          TYPE csequence
    RETURNING VALUE(ro_member) TYPE REF TO if_xco_cp_clas_member.
ENDINTERFACE.
