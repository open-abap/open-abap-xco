INTERFACE if_xco_ao_c_definition PUBLIC.
  TYPES: BEGIN OF ts_sections,
           public TYPE REF TO if_xco_ao_c_section,
         END OF ts_sections.

  DATA section TYPE ts_sections READ-ONLY.
ENDINTERFACE.
