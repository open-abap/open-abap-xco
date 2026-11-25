CLASS cl_xco_cds_ann_class DEFINITION PUBLIC.
  PUBLIC SECTION.
* iv_layer: AGGREGATED, DIRECT, INHERITED, DERIVED or METADATA_EXTENSION
    METHODS constructor
      IMPORTING
        iv_layer TYPE string.

    METHODS of
      IMPORTING
        io_target             TYPE REF TO if_xco_cds_ann_target
      RETURNING
        VALUE(ro_annotations) TYPE REF TO if_xco_cds_annotations.

  PRIVATE SECTION.
    DATA mv_layer TYPE string.
ENDCLASS.

CLASS cl_xco_cds_ann_class IMPLEMENTATION.
  METHOD constructor.
    mv_layer = iv_layer.
  ENDMETHOD.

  METHOD of.
* the runtime metadata only holds the annotations written in the own source, metadata extensions,
* inheritance and derivation are not available, so aggregated equals direct
    DATA lt_annotations TYPE cl_xco_runtime_ddic=>ty_annotations.

    IF mv_layer = 'AGGREGATED' OR mv_layer = 'DIRECT'.
      IF io_target IS INSTANCE OF cl_xco_cds_entity.
        lt_annotations = CAST cl_xco_cds_entity( io_target )->get_metadata( )-annotations.
      ELSEIF io_target IS INSTANCE OF cl_xco_cds_field.
        lt_annotations = CAST cl_xco_cds_field( io_target )->get_annotations( ).
      ENDIF.
    ENDIF.

    ro_annotations = NEW cl_xco_cds_annotations( lt_annotations ).
  ENDMETHOD.
ENDCLASS.
