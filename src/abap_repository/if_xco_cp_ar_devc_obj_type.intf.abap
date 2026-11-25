INTERFACE if_xco_cp_ar_devc_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name           TYPE csequence
    RETURNING VALUE(ro_package) TYPE REF TO if_xco_package.
ENDINTERFACE.
