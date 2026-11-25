INTERFACE if_xco_cds_composition_ct PUBLIC.
  TYPES: BEGIN OF ts_composition,
           target TYPE sxco_cds_object_name,
         END OF ts_composition.
  TYPES: BEGIN OF ts_content,
           alias TYPE sxco_cds_association_name,
         END OF ts_content.

  DATA composition TYPE ts_composition READ-ONLY.
  DATA target TYPE sxco_cds_object_name READ-ONLY.

  METHODS get
    RETURNING VALUE(rs_content) TYPE ts_content.
ENDINTERFACE.
