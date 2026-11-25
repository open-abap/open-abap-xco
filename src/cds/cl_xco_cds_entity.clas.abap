CLASS cl_xco_cds_entity DEFINITION PUBLIC FINAL CREATE PUBLIC.
* read access to a CDS entity, the metadata is read on first use, so handles can point to each other
  PUBLIC SECTION.
    INTERFACES if_xco_cds_view_entity.
    INTERFACES if_xco_cds_view.
    INTERFACES if_xco_cds_projection_view.
    INTERFACES if_xco_cds_abstract_entity.
    INTERFACES if_xco_cds_custom_entity.
    INTERFACES if_xco_cds_table_function.

* iv_definition_type: the expected definition type, eg. VIEW_ENTITY, initial for any
    METHODS constructor
      IMPORTING
        iv_name            TYPE csequence
        iv_definition_type TYPE string OPTIONAL.

    METHODS get_metadata
      RETURNING
        VALUE(rs_cds) TYPE cl_xco_runtime_ddic=>ty_cds.

  PRIVATE SECTION.
    DATA mv_definition_type TYPE string.
    DATA mv_read TYPE abap_bool.
    DATA ms_cds TYPE cl_xco_runtime_ddic=>ty_cds.
ENDCLASS.

CLASS cl_xco_cds_entity IMPLEMENTATION.
  METHOD constructor.
    DATA lo_fields TYPE REF TO cl_xco_cds_fields.
    DATA lo_associations TYPE REF TO cl_xco_cds_associations.
    DATA lo_compositions TYPE REF TO cl_xco_cds_compositions.

    if_xco_ar_object~name = to_upper( condense( iv_name ) ).
    mv_definition_type = iv_definition_type.

    lo_fields = NEW #( me ).
    lo_associations = NEW #( me ).
    lo_compositions = NEW #( me ).

    if_xco_cds_entity~fields = lo_fields.
    if_xco_cds_view~fields = lo_fields.
    if_xco_cds_view~associations = lo_associations.
    if_xco_cds_view~compositions = lo_compositions.
    if_xco_cds_view_entity~associations = lo_associations.
    if_xco_cds_view_entity~compositions = lo_compositions.
  ENDMETHOD.

  METHOD get_metadata.
    IF mv_read = abap_false.
      ms_cds = cl_xco_runtime_ddic=>cds( if_xco_ar_object~name ).
      mv_read = abap_true.
    ENDIF.
    rs_cds = ms_cds.
  ENDMETHOD.

  METHOD if_xco_ar_object~exists.
    DATA(ls_cds) = get_metadata( ).
    rv_exists = xsdbool( ls_cds-found = abap_true
      AND ( mv_definition_type IS INITIAL OR ls_cds-definition_type = mv_definition_type ) ).
  ENDMETHOD.

  METHOD if_xco_ar_object~get_namespace.
    rv_namespace = cl_xco_runtime_ddic=>namespace( if_xco_ar_object~name ).
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

  METHOD if_xco_cds_entity~get_api_state.
* the transpiler emits no content for APIS objects, the release state is only known without one: not released
    IF cl_xco_runtime_ddic=>tadir_exists(
        iv_object = 'APIS'
        iv_name   = if_xco_ar_object~name ) = abap_true.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    ro_api_state = NEW #( xco_cp_ars=>release_state->not_released ).
  ENDMETHOD.

  METHOD if_xco_cds_entity~add_annotation.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_cds_entity~add_association.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_cds_entity~add_composition.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_cds_entity~add_field.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_cds_entity~set_where.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_cds_entity~set_root.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_gen_cds_s_fo_ann_target~add_annotation.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_printable~get_text.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
