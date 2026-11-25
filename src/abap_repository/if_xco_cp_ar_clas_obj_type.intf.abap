INTERFACE if_xco_cp_ar_clas_obj_type PUBLIC.
  METHODS for
    IMPORTING iv_name         TYPE csequence
    RETURNING VALUE(ro_class) TYPE REF TO if_xco_ao_class.
ENDINTERFACE.
