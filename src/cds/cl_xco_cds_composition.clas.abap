CLASS cl_xco_cds_composition DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cds_composition.
    INTERFACES if_xco_cds_composition_ct.

    METHODS constructor
      IMPORTING
        is_association TYPE cl_xco_runtime_ddic=>ty_cds_association.

  PRIVATE SECTION.
    DATA mv_alias TYPE string.
ENDCLASS.

CLASS cl_xco_cds_composition IMPLEMENTATION.
  METHOD constructor.
    mv_alias = is_association-name.
    if_xco_cds_composition~target = NEW cl_xco_cds_entity( is_association-target ).
    if_xco_cds_composition~composition = me.
    if_xco_cds_composition_ct~target = is_association-target.
    if_xco_cds_composition_ct~composition-target = is_association-target.
  ENDMETHOD.

  METHOD if_xco_cds_composition~content.
    ro_content = me.
  ENDMETHOD.

  METHOD if_xco_cds_composition_ct~get.
    rs_content-alias = mv_alias.
  ENDMETHOD.
ENDCLASS.
