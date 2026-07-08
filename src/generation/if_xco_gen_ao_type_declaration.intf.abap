INTERFACE if_xco_gen_ao_type_declaration PUBLIC.
  METHODS type
    IMPORTING iv_name        TYPE csequence
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_table_type.
ENDINTERFACE.
