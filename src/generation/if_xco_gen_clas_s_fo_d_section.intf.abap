INTERFACE if_xco_gen_clas_s_fo_d_section PUBLIC.
  TYPES tv_method_name TYPE c LENGTH 30.

  METHODS add_type IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_member) TYPE REF TO if_xco_gen_ao_s_fo_component.
  METHODS add_method IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_member) TYPE REF TO if_xco_gen_ao_s_fo_component.
  METHODS add_data IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_member) TYPE REF TO if_xco_gen_ao_s_fo_component.
ENDINTERFACE.
