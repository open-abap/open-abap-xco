INTERFACE if_xco_cp_clas_own PUBLIC.
  METHODS type
    IMPORTING iv_name        TYPE csequence
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
ENDINTERFACE.
