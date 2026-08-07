INTERFACE if_xco_clas_definition PUBLIC.
  TYPES: BEGIN OF ts_section,
           public    TYPE REF TO if_xco_clas_definition_section,
           protected TYPE REF TO if_xco_clas_definition_section,
           private   TYPE REF TO if_xco_clas_definition_section,
         END OF ts_section.
ENDINTERFACE.
