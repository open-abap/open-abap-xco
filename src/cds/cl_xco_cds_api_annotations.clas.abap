CLASS cl_xco_cds_api_annotations DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_cds_api_annotations.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cds_api_annotations IMPLEMENTATION.
  METHOD constructor.
    if_xco_cp_cds_api_annotations~aggregated = NEW #( 'AGGREGATED' ).
    if_xco_cp_cds_api_annotations~direct = NEW #( 'DIRECT' ).
    if_xco_cp_cds_api_annotations~inherited = NEW #( 'INHERITED' ).
    if_xco_cp_cds_api_annotations~derived = NEW #( 'DERIVED' ).
    if_xco_cp_cds_api_annotations~metadata_extension = NEW #( 'METADATA_EXTENSION' ).
  ENDMETHOD.
ENDCLASS.
