CLASS cl_xco_cds_associations DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cds_associations_fctry.
    INTERFACES if_xco_cds_associations.

    METHODS constructor
      IMPORTING
        io_entity TYPE REF TO cl_xco_cds_entity.

  PRIVATE SECTION.
    DATA mo_entity TYPE REF TO cl_xco_cds_entity.
ENDCLASS.

CLASS cl_xco_cds_associations IMPLEMENTATION.
  METHOD constructor.
    mo_entity = io_entity.
    if_xco_cds_associations_fctry~all = me.
  ENDMETHOD.

  METHOD if_xco_cds_associations~get.
* the exposed associations in declaration order, compositions are listed by the compositions factory
    DATA(ls_cds) = mo_entity->get_metadata( ).
    LOOP AT ls_cds-associations INTO DATA(ls_association)
        WHERE exposed = abap_true AND kind <> 'COMPOSITION'.
      APPEND NEW cl_xco_cds_association( ls_association ) TO rt_associations.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
