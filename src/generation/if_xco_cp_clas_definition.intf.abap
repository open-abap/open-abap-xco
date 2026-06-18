INTERFACE if_xco_cp_clas_definition PUBLIC.
  TYPES: BEGIN OF ts_section,
           public TYPE REF TO if_xco_cp_clas_section,
         END OF ts_section.

  DATA section TYPE ts_section READ-ONLY.

  METHODS add_interface
    IMPORTING iv_interface         TYPE csequence
    RETURNING VALUE(ro_definition) TYPE REF TO if_xco_cp_clas_definition.
ENDINTERFACE.
