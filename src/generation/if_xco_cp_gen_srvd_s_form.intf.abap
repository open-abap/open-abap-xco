INTERFACE if_xco_cp_gen_srvd_s_form PUBLIC.
  INTERFACES if_xco_gen_cds_s_fo_ann_target.

  ALIASES add_annotation FOR if_xco_gen_cds_s_fo_ann_target~add_annotation.

  METHODS set_short_description
    IMPORTING iv_short_description TYPE csequence
    RETURNING VALUE(ro_form)       TYPE REF TO if_xco_cp_gen_srvd_s_form.
  METHODS add_exposure
    IMPORTING iv_name            TYPE csequence
    RETURNING VALUE(ro_exposure) TYPE REF TO if_xco_gen_srvb_s_fo_service.
ENDINTERFACE.
