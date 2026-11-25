CLASS cl_xco_cds_association DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cds_association.
    INTERFACES if_xco_cds_assoc_content.

    METHODS constructor
      IMPORTING
        is_association TYPE cl_xco_runtime_ddic=>ty_cds_association.

  PRIVATE SECTION.
    DATA ms_association TYPE cl_xco_runtime_ddic=>ty_cds_association.
ENDCLASS.

CLASS cl_xco_cds_association IMPLEMENTATION.
  METHOD constructor.
    ms_association = is_association.
    if_xco_cds_association~name = is_association-name.
    if_xco_cds_association~entity = NEW cl_xco_cds_entity( is_association-target ).
  ENDMETHOD.

  METHOD if_xco_cds_association~content.
    ro_content = me.
  ENDMETHOD.

  METHOD if_xco_cds_assoc_content~get_to_parent_indicator.
    rv_to_parent = xsdbool( ms_association-kind = 'TO_PARENT' ).
  ENDMETHOD.

  METHOD if_xco_cds_assoc_content~get_target.
    rv_target = ms_association-target.
  ENDMETHOD.
ENDCLASS.
