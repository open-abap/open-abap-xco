INTERFACE if_xco_gen_bdef_s_fo_b_etag PUBLIC.
  METHODS set_master
    IMPORTING iv_master      TYPE csequence OPTIONAL
    RETURNING VALUE(ro_etag) TYPE REF TO if_xco_gen_bdef_s_fo_b_etag.
  METHODS set_dependent_by
    IMPORTING iv_association TYPE csequence
    RETURNING VALUE(ro_etag) TYPE REF TO if_xco_gen_bdef_s_fo_b_etag.
  METHODS set_use
    RETURNING VALUE(ro_etag) TYPE REF TO if_xco_gen_bdef_s_fo_b_etag.
ENDINTERFACE.
