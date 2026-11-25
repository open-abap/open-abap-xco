CLASS cl_xco_ddef_type_f DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA view             TYPE REF TO cl_xco_ddef_type READ-ONLY.
    DATA extend           TYPE REF TO cl_xco_ddef_type READ-ONLY.
    DATA table_function   TYPE REF TO cl_xco_ddef_type READ-ONLY.
    DATA table_entity     TYPE REF TO cl_xco_ddef_type READ-ONLY.
    DATA abstract_entity  TYPE REF TO cl_xco_ddef_type READ-ONLY.
    DATA hierarchy        TYPE REF TO cl_xco_ddef_type READ-ONLY.
    DATA custom_entity    TYPE REF TO cl_xco_ddef_type READ-ONLY.
    DATA projection_view  TYPE REF TO cl_xco_ddef_type READ-ONLY.
    DATA extend_version_2 TYPE REF TO cl_xco_ddef_type READ-ONLY.
    DATA view_entity      TYPE REF TO cl_xco_ddef_type READ-ONLY.

    METHODS constructor.

* the type for a definition type of the transpiler's CDS metadata, unbound if unknown
    METHODS for_definition_type
      IMPORTING
        iv_definition_type TYPE string
      RETURNING
        VALUE(ro_type)     TYPE REF TO cl_xco_ddef_type.
ENDCLASS.

CLASS cl_xco_ddef_type_f IMPLEMENTATION.
  METHOD constructor.
* values are the abapGit SOURCE_TYPE of the DDLS
    view = NEW #( 'V' ).
    extend = NEW #( 'E' ).
    table_function = NEW #( 'F' ).
    table_entity = NEW #( 'T' ).
    abstract_entity = NEW #( 'A' ).
    hierarchy = NEW #( 'H' ).
    custom_entity = NEW #( 'Q' ).
    projection_view = NEW #( 'P' ).
    extend_version_2 = NEW #( 'X' ).
    view_entity = NEW #( 'W' ).
  ENDMETHOD.

  METHOD for_definition_type.
    CASE iv_definition_type.
      WHEN 'VIEW'.
        ro_type = view.
      WHEN 'VIEW_ENTITY'.
        ro_type = view_entity.
      WHEN 'PROJECTION_VIEW'.
        ro_type = projection_view.
      WHEN 'ABSTRACT_ENTITY'.
        ro_type = abstract_entity.
      WHEN 'CUSTOM_ENTITY'.
        ro_type = custom_entity.
      WHEN 'TABLE_FUNCTION'.
        ro_type = table_function.
      WHEN 'HIERARCHY'.
        ro_type = hierarchy.
      WHEN 'TABLE_ENTITY'.
        ro_type = table_entity.
      WHEN 'CDSExtendView'.
        ro_type = extend.
      WHEN OTHERS.
        CLEAR ro_type.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
