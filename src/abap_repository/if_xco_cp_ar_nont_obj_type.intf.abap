INTERFACE if_xco_cp_ar_nont_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name                        TYPE csequence
    RETURNING VALUE(ro_sap_object_node_type) TYPE REF TO if_xco_sap_object_node_type.
ENDINTERFACE.
