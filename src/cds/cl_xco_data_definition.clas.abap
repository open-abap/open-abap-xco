CLASS cl_xco_data_definition DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_data_definition.

    METHODS constructor
      IMPORTING
        iv_name TYPE csequence.

  PRIVATE SECTION.
    METHODS entity_name
      IMPORTING
        iv_name        TYPE sxco_cds_object_name
      RETURNING
        VALUE(rv_name) TYPE sxco_cds_object_name.
ENDCLASS.

CLASS cl_xco_data_definition IMPLEMENTATION.
  METHOD constructor.
    if_xco_data_definition~name = to_upper( condense( iv_name ) ).
    if_xco_ar_object~name = if_xco_data_definition~name.
  ENDMETHOD.

  METHOD entity_name.
* a data definition defines one entity, with the same name
    rv_name = COND #( WHEN iv_name IS INITIAL THEN if_xco_data_definition~name ELSE iv_name ).
  ENDMETHOD.

  METHOD if_xco_ar_object~exists.
    rv_exists = xsdbool( cl_xco_runtime_ddic=>object_type( if_xco_data_definition~name ) = 'DDLS' ).
  ENDMETHOD.

  METHOD if_xco_ar_object~get_namespace.
    rv_namespace = cl_xco_runtime_ddic=>namespace( if_xco_data_definition~name ).
  ENDMETHOD.

  METHOD if_xco_ar_object~get_package.
    CLEAR ro_package.
  ENDMETHOD.

  METHOD if_xco_ar_object~get_original_language.
    CLEAR ro_original_language.
  ENDMETHOD.

  METHOD if_xco_ar_object~get_state.
    CLEAR ro_state.
  ENDMETHOD.

  METHOD if_xco_data_definition~check_syntax.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_data_definition~get_type.
    DATA(ls_cds) = cl_xco_runtime_ddic=>cds( if_xco_data_definition~name ).
    ro_type = xco_cp_data_definition=>type->for_definition_type( ls_cds-definition_type ).
  ENDMETHOD.

  METHOD if_xco_data_definition~get_state.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_data_definition~entity.
    ro_entity = NEW cl_xco_cds_entity( entity_name( iv_name ) ).
  ENDMETHOD.

  METHOD if_xco_data_definition~view.
    ro_view = NEW cl_xco_cds_entity(
      iv_name            = entity_name( iv_name )
      iv_definition_type = 'VIEW' ).
  ENDMETHOD.

  METHOD if_xco_data_definition~view_entity.
    ro_view_entiy = NEW cl_xco_cds_entity(
      iv_name            = entity_name( iv_name )
      iv_definition_type = 'VIEW_ENTITY' ).
  ENDMETHOD.

  METHOD if_xco_data_definition~projection_view.
    ro_projection_view = NEW cl_xco_cds_entity(
      iv_name            = entity_name( iv_name )
      iv_definition_type = 'PROJECTION_VIEW' ).
  ENDMETHOD.

  METHOD if_xco_data_definition~abstract_entity.
    ro_abstract_entity = NEW cl_xco_cds_entity(
      iv_name            = if_xco_data_definition~name
      iv_definition_type = 'ABSTRACT_ENTITY' ).
  ENDMETHOD.

  METHOD if_xco_data_definition~custom_entity.
    ro_custom_entity = NEW cl_xco_cds_entity(
      iv_name            = if_xco_data_definition~name
      iv_definition_type = 'CUSTOM_ENTITY' ).
  ENDMETHOD.

  METHOD if_xco_data_definition~table_function.
    ro_table_function = NEW cl_xco_cds_entity(
      iv_name            = if_xco_data_definition~name
      iv_definition_type = 'TABLE_FUNCTION' ).
  ENDMETHOD.
ENDCLASS.
