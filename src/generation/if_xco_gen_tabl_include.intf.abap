INTERFACE if_xco_gen_tabl_include PUBLIC.
  METHODS set_structure
    IMPORTING iv_structure      TYPE csequence
    RETURNING VALUE(ro_include) TYPE REF TO if_xco_gen_tabl_include.
  METHODS set_group_name
    IMPORTING iv_group_name     TYPE csequence
    RETURNING VALUE(ro_include) TYPE REF TO if_xco_gen_tabl_include.
ENDINTERFACE.
