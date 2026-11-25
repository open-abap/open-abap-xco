CLASS cl_xco_cds_fields DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cds_fields_factory.
    INTERFACES if_xco_cds_fields.

    METHODS constructor
      IMPORTING
        io_entity TYPE REF TO cl_xco_cds_entity.

  PRIVATE SECTION.
    DATA mo_entity TYPE REF TO cl_xco_cds_entity.
ENDCLASS.

CLASS cl_xco_cds_fields IMPLEMENTATION.
  METHOD constructor.
    mo_entity = io_entity.
    if_xco_cds_fields_factory~all = me.
  ENDMETHOD.

  METHOD if_xco_cds_fields~get.
* in declaration order, exposed associations are not fields
    DATA(ls_cds) = mo_entity->get_metadata( ).
    LOOP AT ls_cds-fields INTO DATA(ls_field).
      APPEND NEW cl_xco_cds_field( ls_field ) TO rt_fields.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
