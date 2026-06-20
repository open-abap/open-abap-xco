INTERFACE if_xco_gen_clas_s_fo_b_impl PUBLIC.
  METHODS set_result
    IMPORTING iv_result                TYPE csequence
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for
    IMPORTING iv_for                   TYPE csequence
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_request
    IMPORTING iv_request               TYPE csequence
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for_global_authorization
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for_instance_authorization
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for_instance_features
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for_modify
    IMPORTING iv_entity_name           TYPE csequence OPTIONAL
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for_read
    IMPORTING iv_entity_name           TYPE csequence OPTIONAL
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for_action
    IMPORTING iv_action_name           TYPE csequence OPTIONAL
              iv_entity_name           TYPE csequence OPTIONAL
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for_create
    IMPORTING iv_entity_name           TYPE csequence OPTIONAL
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for_update
    IMPORTING iv_entity_name           TYPE csequence OPTIONAL
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for_delete
    IMPORTING iv_entity_name           TYPE csequence OPTIONAL
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_for_lock
    IMPORTING iv_entity_name           TYPE csequence OPTIONAL
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_link
    IMPORTING iv_association_name      TYPE csequence OPTIONAL
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
  METHODS set_full
    IMPORTING iv_result                TYPE csequence OPTIONAL
    RETURNING VALUE(ro_implementation) TYPE REF TO if_xco_gen_clas_s_fo_b_impl.
ENDINTERFACE.
