CLASS cl_xco_cds_compositions DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cds_compositions_fctry.
    INTERFACES if_xco_cds_compositions.

    METHODS constructor
      IMPORTING
        io_entity TYPE REF TO cl_xco_cds_entity.

  PRIVATE SECTION.
    DATA mo_entity TYPE REF TO cl_xco_cds_entity.
ENDCLASS.

CLASS cl_xco_cds_compositions IMPLEMENTATION.
  METHOD constructor.
    mo_entity = io_entity.
    if_xco_cds_compositions_fctry~all = me.
  ENDMETHOD.

  METHOD if_xco_cds_compositions~get.
    DATA(ls_cds) = mo_entity->get_metadata( ).
    LOOP AT ls_cds-associations INTO DATA(ls_association)
        WHERE exposed = abap_true AND kind = 'COMPOSITION'.
      APPEND NEW cl_xco_cds_composition( ls_association ) TO rt_compositions.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
