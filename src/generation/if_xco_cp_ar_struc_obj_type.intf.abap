INTERFACE if_xco_cp_ar_struc_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name             TYPE csequence
    RETURNING VALUE(ro_structure) TYPE REF TO if_xco_ad_structure.
ENDINTERFACE.
