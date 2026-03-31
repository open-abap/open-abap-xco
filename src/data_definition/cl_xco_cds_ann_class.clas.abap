
CLASS cl_xco_cds_ann_class DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS of
      IMPORTING
        io_target             TYPE REF TO if_xco_cds_ann_target
      RETURNING
        VALUE(ro_annotations) TYPE REF TO if_xco_cds_annotations.

ENDCLASS.

CLASS cl_xco_cds_ann_class IMPLEMENTATION.
  METHOD of.
    RETURN. " todo, implement method
  ENDMETHOD.

ENDCLASS.
