INTERFACE if_xco_cp_clas_section PUBLIC.
  METHODS add_type IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_member) TYPE REF TO if_xco_cp_clas_member.
  METHODS add_method IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_member) TYPE REF TO if_xco_cp_clas_member.
  METHODS add_data IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_member) TYPE REF TO if_xco_cp_clas_member.
ENDINTERFACE.
