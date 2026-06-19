INTERFACE if_xco_gen_cds_s_fo_ann_value PUBLIC.
  METHODS build RETURNING VALUE(ro_builder) TYPE REF TO if_xco_gen_cds_s_fo_ann_v_bldr.
  METHODS add_string IMPORTING iv_value TYPE csequence RETURNING VALUE(ro_builder) TYPE REF TO if_xco_gen_cds_s_fo_ann_value.
  METHODS add_enum IMPORTING iv_value TYPE csequence RETURNING VALUE(ro_builder) TYPE REF TO if_xco_gen_cds_s_fo_ann_value.
  METHODS add_boolean IMPORTING iv_value TYPE abap_bool RETURNING VALUE(ro_builder) TYPE REF TO if_xco_gen_cds_s_fo_ann_value.
  METHODS add_number IMPORTING iv_value TYPE csequence RETURNING VALUE(ro_builder) TYPE REF TO if_xco_gen_cds_s_fo_ann_value.
  METHODS add_member IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_builder) TYPE REF TO if_xco_gen_cds_s_fo_ann_value.
  METHODS begin_array RETURNING VALUE(ro_builder) TYPE REF TO if_xco_gen_cds_s_fo_ann_value.
  METHODS end_array RETURNING VALUE(ro_builder) TYPE REF TO if_xco_gen_cds_s_fo_ann_value.
  METHODS begin_record RETURNING VALUE(ro_builder) TYPE REF TO if_xco_gen_cds_s_fo_ann_value.
  METHODS end_record RETURNING VALUE(ro_builder) TYPE REF TO if_xco_gen_cds_s_fo_ann_value.
ENDINTERFACE.
