INTERFACE if_xco_clas_definition PUBLIC.
  TYPES: BEGIN OF ts_section,
           public    TYPE REF TO if_xco_clas_definition_section,
           protected TYPE REF TO if_xco_clas_definition_section,
           private   TYPE REF TO if_xco_clas_definition_section,
         END OF ts_section.

  METHODS content
    RETURNING
      VALUE(ro_content) TYPE REF TO if_xco_clas_definition_content.

  DATA class   TYPE REF TO if_xco_ao_class READ-ONLY.
  DATA section TYPE ts_section READ-ONLY.
ENDINTERFACE.
