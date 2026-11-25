INTERFACE if_xco_cp_ar_ddlx_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name                      TYPE csequence
    RETURNING VALUE(ro_metadata_extension) TYPE REF TO if_xco_metadata_extension.
ENDINTERFACE.
