INTERFACE if_xco_cp_ar_ddls_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name                   TYPE csequence
    RETURNING VALUE(ro_data_definition) TYPE REF TO if_xco_data_definition.
ENDINTERFACE.
