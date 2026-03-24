CLASS xco_cp_cds DEFINITION PUBLIC.
  PUBLIC SECTION.

    CLASS-DATA:
      cardinality                 TYPE REF TO cl_xco_cds_cardinality_f READ-ONLY,
      left_outer_join_cardinality TYPE REF TO cl_xco_cds_left_outer_join_c_f READ-ONLY,
      provider_contract           TYPE REF TO cl_xco_cp_cds_prvdr_cntrct_f READ-ONLY,
      annotations                 TYPE REF TO if_xco_cp_cds_api_annotations READ-ONLY.

    CLASS-METHODS:
      access_control
        IMPORTING
          iv_name                  TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_access_control) TYPE REF TO if_xco_access_control,
      behavior_definition
        IMPORTING
          iv_name                       TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_behavior_definition) TYPE REF TO if_xco_behavior_definition,
      data_definition
        IMPORTING
          iv_name                   TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_data_definition) TYPE REF TO if_xco_data_definition,
      metadata_extension
        IMPORTING
          iv_name                      TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_metadata_extension) TYPE REF TO if_xco_metadata_extension,
      entity
        IMPORTING
          iv_name          TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_entity) TYPE REF TO if_xco_cds_entity,
      view
        IMPORTING
          iv_name        TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_view) TYPE REF TO if_xco_cds_view,
      view_entity
        IMPORTING
          iv_name               TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_view_entity) TYPE REF TO if_xco_cds_view_entity,
      projection_view
        IMPORTING
          iv_name                   TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_projection_view) TYPE REF TO if_xco_cds_projection_view,
      abstract_entity
        IMPORTING
          iv_name                   TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_abstract_entity) TYPE REF TO if_xco_cds_abstract_entity,
      custom_entity
        IMPORTING
          iv_name                 TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_custom_entity) TYPE REF TO if_xco_cds_custom_entity,
      table_function
        IMPORTING
          iv_name                  TYPE sxco_cds_object_name
        RETURNING
          VALUE(ro_table_function) TYPE REF TO if_xco_cds_table_function.

ENDCLASS.

CLASS xco_cp_cds IMPLEMENTATION.
  METHOD access_control.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD behavior_definition.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD data_definition.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD metadata_extension.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD entity.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD view.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD view_entity.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD projection_view.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD abstract_entity.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD custom_entity.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD table_function.
    RETURN. " todo, implement method
  ENDMETHOD.

ENDCLASS.