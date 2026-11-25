* Fixtures: test/fixtures, ZI_XCOT_* / ZC_XCOT_* / ZD_XCOT_* / ZF_XCOT_*
* Names returned by XCO are compared in upper case, the tests check content and order, not spelling

CLASS ltcl_names DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    CLASS-METHODS field_names
      IMPORTING
        it_fields       TYPE sxco_t_cds_fields
      RETURNING
        VALUE(rt_names) TYPE string_table.

    CLASS-METHODS key_indicators
      IMPORTING
        it_fields       TYPE sxco_t_cds_fields
      RETURNING
        VALUE(rt_names) TYPE string_table.

    CLASS-METHODS association_names
      IMPORTING
        it_associations TYPE sxco_t_cds_associations
      RETURNING
        VALUE(rt_names) TYPE string_table.

    CLASS-METHODS association_targets
      IMPORTING
        it_associations   TYPE sxco_t_cds_associations
      RETURNING
        VALUE(rt_targets) TYPE string_table.
ENDCLASS.

CLASS ltcl_names IMPLEMENTATION.
  METHOD field_names.
    LOOP AT it_fields INTO DATA(lo_field).
      APPEND to_upper( lo_field->name ) TO rt_names.
    ENDLOOP.
  ENDMETHOD.

  METHOD key_indicators.
* one row per field in declaration order, "NAME:X" for key fields and "NAME:" for others
    LOOP AT it_fields INTO DATA(lo_field).
      APPEND |{ to_upper( lo_field->name ) }:{ lo_field->content( )->get_key_indicator( ) }| TO rt_names.
    ENDLOOP.
  ENDMETHOD.

  METHOD association_names.
    LOOP AT it_associations INTO DATA(lo_association).
      APPEND to_upper( lo_association->name ) TO rt_names.
    ENDLOOP.
  ENDMETHOD.

  METHOD association_targets.
    LOOP AT it_associations INTO DATA(lo_association).
      APPEND to_upper( lo_association->content( )->get_target( ) ) TO rt_targets.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_data_definition DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS existing FOR TESTING.
    METHODS missing FOR TESTING.
    METHODS types_are_distinct FOR TESTING.
    METHODS type_view FOR TESTING.
    METHODS type_view_entity FOR TESTING.
    METHODS type_projection_view FOR TESTING.
    METHODS type_abstract_entity FOR TESTING.
    METHODS type_custom_entity FOR TESTING.
    METHODS type_table_function FOR TESTING.
    METHODS type_hierarchy FOR TESTING.

    METHODS assert_type
      IMPORTING
        iv_name TYPE sxco_cds_object_name
        io_exp  TYPE REF TO cl_xco_ddef_type.
ENDCLASS.

CLASS ltcl_data_definition IMPLEMENTATION.
  METHOD assert_type.
    cl_abap_unit_assert=>assert_bound( io_exp ).

    DATA(lo_act) = xco_cds=>data_definition( iv_name )->get_type( ).

    cl_abap_unit_assert=>assert_bound( lo_act ).
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( lo_act = io_exp )
      msg = |{ iv_name }: unexpected type "{ lo_act->value }", expected "{ io_exp->value }"| ).
  ENDMETHOD.

  METHOD existing.
    DATA(lo_data_definition) = xco_cds=>data_definition( 'ZI_XCOT_ORDER' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_data_definition->name
      exp = 'ZI_XCOT_ORDER' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_data_definition->exists( )
      exp = abap_true ).
  ENDMETHOD.

  METHOD missing.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cds=>data_definition( 'ZI_XCOT_MISSING' )->exists( )
      exp = abap_false ).
  ENDMETHOD.

  METHOD types_are_distinct.
* guards the type tests below, they compare references and must not pass with one shared or initial instance
    TYPES ty_types TYPE STANDARD TABLE OF REF TO cl_xco_ddef_type WITH DEFAULT KEY.
    DATA lt_types TYPE ty_types.

    lt_types = VALUE #(
      ( xco_cp_data_definition=>type->view )
      ( xco_cp_data_definition=>type->view_entity )
      ( xco_cp_data_definition=>type->projection_view )
      ( xco_cp_data_definition=>type->abstract_entity )
      ( xco_cp_data_definition=>type->custom_entity )
      ( xco_cp_data_definition=>type->table_function )
      ( xco_cp_data_definition=>type->hierarchy ) ).

    LOOP AT lt_types INTO DATA(lo_type).
      cl_abap_unit_assert=>assert_bound( lo_type ).
      DATA(lv_same) = 0.
      LOOP AT lt_types INTO DATA(lo_other).
        IF lo_other = lo_type.
          lv_same = lv_same + 1.
        ENDIF.
      ENDLOOP.
      cl_abap_unit_assert=>assert_equals(
        act = lv_same
        exp = 1
        msg = |type { lo_type->value } is shared| ).
    ENDLOOP.
  ENDMETHOD.

  METHOD type_view.
    assert_type(
      iv_name = 'ZI_XCOT_ORDERVIEW'
      io_exp  = xco_cp_data_definition=>type->view ).
  ENDMETHOD.

  METHOD type_view_entity.
    assert_type(
      iv_name = 'ZI_XCOT_ORDER'
      io_exp  = xco_cp_data_definition=>type->view_entity ).
  ENDMETHOD.

  METHOD type_projection_view.
    assert_type(
      iv_name = 'ZC_XCOT_ORDER'
      io_exp  = xco_cp_data_definition=>type->projection_view ).
  ENDMETHOD.

  METHOD type_abstract_entity.
    assert_type(
      iv_name = 'ZD_XCOT_PARAMS'
      io_exp  = xco_cp_data_definition=>type->abstract_entity ).
  ENDMETHOD.

  METHOD type_custom_entity.
    assert_type(
      iv_name = 'ZI_XCOT_CUSTOM'
      io_exp  = xco_cp_data_definition=>type->custom_entity ).
  ENDMETHOD.

  METHOD type_table_function.
    assert_type(
      iv_name = 'ZF_XCOT_TABFUNC'
      io_exp  = xco_cp_data_definition=>type->table_function ).
  ENDMETHOD.

  METHOD type_hierarchy.
    assert_type(
      iv_name = 'ZI_XCOT_HIERARCHY'
      io_exp  = xco_cp_data_definition=>type->hierarchy ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_entity DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS existing FOR TESTING.
    METHODS missing FOR TESTING.
    METHODS released_c1 FOR TESTING.
    METHODS not_released_c1 FOR TESTING.

    METHODS get_c1_release_state
      IMPORTING
        iv_name         TYPE sxco_cds_object_name
      RETURNING
        VALUE(ro_state) TYPE REF TO cl_xco_ars_release_state.
ENDCLASS.

CLASS ltcl_entity IMPLEMENTATION.
  METHOD get_c1_release_state.
    cl_abap_unit_assert=>assert_bound( xco_cp_ars=>release_contract->c1 ).
    cl_abap_unit_assert=>assert_bound( xco_cp_ars=>release_state->released ).
    cl_abap_unit_assert=>assert_bound( xco_cp_ars=>release_state->not_released ).
    cl_abap_unit_assert=>assert_true( xsdbool( xco_cp_ars=>release_state->released <> xco_cp_ars=>release_state->not_released ) ).

    ro_state = xco_cds=>entity( iv_name )->get_api_state( xco_cp_ars=>release_contract->c1 )->get_release_state( ).
  ENDMETHOD.

  METHOD existing.
    DATA(lo_entity) = xco_cds=>entity( 'ZI_XCOT_ORDER' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_entity->if_xco_ar_object~name
      exp = 'ZI_XCOT_ORDER' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_entity->if_xco_ar_object~exists( )
      exp = abap_true ).
  ENDMETHOD.

  METHOD missing.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cds=>entity( 'ZI_XCOT_MISSING' )->if_xco_ar_object~exists( )
      exp = abap_false ).
  ENDMETHOD.

  METHOD released_c1.
* ZI_XCOT_ORDER has an APIS fixture releasing it for contract C1
    DATA(lo_state) = get_c1_release_state( 'ZI_XCOT_ORDER' ).

    cl_abap_unit_assert=>assert_true(
      act = xsdbool( lo_state = xco_cp_ars=>release_state->released )
      msg = 'ZI_XCOT_ORDER is released for C1' ).
  ENDMETHOD.

  METHOD not_released_c1.
    DATA(lo_state) = get_c1_release_state( 'ZI_XCOT_STATUS' ).

    cl_abap_unit_assert=>assert_true(
      act = xsdbool( lo_state = xco_cp_ars=>release_state->not_released )
      msg = 'ZI_XCOT_STATUS is not released for C1' ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_annotations DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS view_entity_present FOR TESTING.
    METHODS view_entity_absent FOR TESTING.
    METHODS classic_view_present FOR TESTING.
    METHODS classic_view_absent FOR TESTING.
    METHODS projection_view FOR TESTING.

    METHODS aggregated
      IMPORTING
        iv_name               TYPE sxco_cds_object_name
      RETURNING
        VALUE(ro_annotations) TYPE REF TO if_xco_cds_annotations.

    METHODS assert_contains
      IMPORTING
        iv_name     TYPE sxco_cds_object_name
        iv_property TYPE sxco_cds_ann_property
        iv_exp      TYPE abap_bool.
ENDCLASS.

CLASS ltcl_annotations IMPLEMENTATION.
  METHOD aggregated.
    ro_annotations = xco_cds=>annotations->aggregated->of( xco_cds=>entity( iv_name ) ).
  ENDMETHOD.

  METHOD assert_contains.
    cl_abap_unit_assert=>assert_equals(
      act = aggregated( iv_name )->contain( iv_property )
      exp = iv_exp
      msg = |{ iv_name } { iv_property }| ).
  ENDMETHOD.

  METHOD view_entity_present.
    assert_contains(
      iv_name     = 'ZI_XCOT_ORDER'
      iv_property = 'AccessControl.authorizationCheck'
      iv_exp      = abap_true ).
    assert_contains(
      iv_name     = 'ZI_XCOT_ORDER'
      iv_property = 'EndUserText.label'
      iv_exp      = abap_true ).
* written as one annotation with a structured value
    assert_contains(
      iv_name     = 'ZI_XCOT_ORDER'
      iv_property = 'ObjectModel.usageType'
      iv_exp      = abap_true ).
  ENDMETHOD.

  METHOD view_entity_absent.
* view entities do not support AbapCatalog.viewEnhancementCategory, the classic view has it
    assert_contains(
      iv_name     = 'ZI_XCOT_ORDER'
      iv_property = 'AbapCatalog.viewEnhancementCategory'
      iv_exp      = abap_false ).
    assert_contains(
      iv_name     = 'ZI_XCOT_ORDER'
      iv_property = 'EndUserText.quickInfo'
      iv_exp      = abap_false ).
  ENDMETHOD.

  METHOD classic_view_present.
    assert_contains(
      iv_name     = 'ZI_XCOT_ORDERVIEW'
      iv_property = 'AbapCatalog.viewEnhancementCategory'
      iv_exp      = abap_true ).
    assert_contains(
      iv_name     = 'ZI_XCOT_ORDERVIEW'
      iv_property = 'AccessControl.authorizationCheck'
      iv_exp      = abap_true ).
    assert_contains(
      iv_name     = 'ZI_XCOT_ORDERVIEW'
      iv_property = 'EndUserText.label'
      iv_exp      = abap_true ).
  ENDMETHOD.

  METHOD classic_view_absent.
    assert_contains(
      iv_name     = 'ZI_XCOT_ORDERVIEW'
      iv_property = 'ObjectModel.usageType'
      iv_exp      = abap_false ).
  ENDMETHOD.

  METHOD projection_view.
    assert_contains(
      iv_name     = 'ZC_XCOT_ORDER'
      iv_property = 'EndUserText.label'
      iv_exp      = abap_true ).
    assert_contains(
      iv_name     = 'ZC_XCOT_ORDER'
      iv_property = 'AbapCatalog.viewEnhancementCategory'
      iv_exp      = abap_false ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_view DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS existing FOR TESTING.
    METHODS missing FOR TESTING.
    METHODS associations FOR TESTING.
    METHODS no_associations FOR TESTING.
ENDCLASS.

CLASS ltcl_view IMPLEMENTATION.
  METHOD existing.
    DATA(lo_view) = xco_cds=>view( 'ZI_XCOT_ORDERVIEW' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_view->name
      exp = 'ZI_XCOT_ORDERVIEW' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_view->exists( )
      exp = abap_true ).
  ENDMETHOD.

  METHOD missing.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cds=>view( 'ZI_XCOT_MISSING' )->exists( )
      exp = abap_false ).
  ENDMETHOD.

  METHOD associations.
    DATA(lt_associations) = xco_cds=>view( 'ZI_XCOT_ORDERVIEW' )->associations->all->get( ).

    cl_abap_unit_assert=>assert_equals(
      act = ltcl_names=>association_names( lt_associations )
      exp = VALUE string_table( ( `_STATUS` ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = ltcl_names=>association_targets( lt_associations )
      exp = VALUE string_table( ( `ZI_XCOT_STATUS` ) ) ).
  ENDMETHOD.

  METHOD no_associations.
    cl_abap_unit_assert=>assert_initial( xco_cds=>view( 'ZI_XCOT_PLAINVIEW' )->associations->all->get( ) ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_view_entity DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS existing FOR TESTING.
    METHODS missing FOR TESTING.
    METHODS field_names_in_declaration_ord FOR TESTING.
    METHODS key_indicators FOR TESTING.
    METHODS without_key_fields FOR TESTING.
    METHODS associations_in_declared_order FOR TESTING.
    METHODS self_association FOR TESTING.
    METHODS no_associations FOR TESTING.
ENDCLASS.

CLASS ltcl_view_entity IMPLEMENTATION.
  METHOD existing.
    DATA(lo_view_entity) = xco_cds=>view_entity( 'ZI_XCOT_ORDER' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_view_entity->name
      exp = 'ZI_XCOT_ORDER' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_view_entity->exists( )
      exp = abap_true ).
  ENDMETHOD.

  METHOD missing.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cds=>view_entity( 'ZI_XCOT_MISSING' )->exists( )
      exp = abap_false ).
  ENDMETHOD.

  METHOD field_names_in_declaration_ord.
* declaration order differs from alphabetical order, and associations are not fields
    DATA(lt_fields) = xco_cds=>view_entity( 'ZI_XCOT_ORDER' )->fields->all->get( ).

    cl_abap_unit_assert=>assert_equals(
      act = ltcl_names=>field_names( lt_fields )
      exp = VALUE string_table(
        ( `ORDERID` )
        ( `ITEMNO` )
        ( `STATUS` )
        ( `DESCRIPTION` ) ) ).
  ENDMETHOD.

  METHOD key_indicators.
* alphabetically a non-key field (DESCRIPTION) comes first, in declaration order the key fields do
    DATA(lt_fields) = xco_cds=>view_entity( 'ZI_XCOT_ORDER' )->fields->all->get( ).

    cl_abap_unit_assert=>assert_equals(
      act = ltcl_names=>key_indicators( lt_fields )
      exp = VALUE string_table(
        ( `ORDERID:X` )
        ( `ITEMNO:X` )
        ( `STATUS:` )
        ( `DESCRIPTION:` ) ) ).
  ENDMETHOD.

  METHOD without_key_fields.
    DATA(lt_fields) = xco_cds=>view_entity( 'ZI_XCOT_STATUS' )->fields->all->get( ).

    cl_abap_unit_assert=>assert_equals(
      act = ltcl_names=>key_indicators( lt_fields )
      exp = VALUE string_table(
        ( `STATUS:` )
        ( `DESCRIPTION:` ) ) ).
  ENDMETHOD.

  METHOD associations_in_declared_order.
* declared as _Status, _Node, alphabetical order would be the reverse
    DATA(lt_associations) = xco_cds=>view_entity( 'ZI_XCOT_ORDER' )->associations->all->get( ).

    cl_abap_unit_assert=>assert_equals(
      act = ltcl_names=>association_names( lt_associations )
      exp = VALUE string_table(
        ( `_STATUS` )
        ( `_NODE` ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = ltcl_names=>association_targets( lt_associations )
      exp = VALUE string_table(
        ( `ZI_XCOT_STATUS` )
        ( `ZI_XCOT_NODE` ) ) ).
  ENDMETHOD.

  METHOD self_association.
    DATA(lt_associations) = xco_cds=>view_entity( 'ZI_XCOT_NODE' )->associations->all->get( ).

    cl_abap_unit_assert=>assert_equals(
      act = ltcl_names=>association_names( lt_associations )
      exp = VALUE string_table( ( `_PARENT` ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = ltcl_names=>association_targets( lt_associations )
      exp = VALUE string_table( ( `ZI_XCOT_NODE` ) ) ).
  ENDMETHOD.

  METHOD no_associations.
    cl_abap_unit_assert=>assert_initial( xco_cds=>view_entity( 'ZI_XCOT_STATUS' )->associations->all->get( ) ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_annotation_values DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS string_value FOR TESTING.
    METHODS enum_value FOR TESTING.
    METHODS boolean_value FOR TESTING.
    METHODS array_value FOR TESTING.
    METHODS object_value FOR TESTING.
    METHODS nested_path FOR TESTING.
    METHODS absent FOR TESTING.
    METHODS field_annotation FOR TESTING.

    METHODS pick
      IMPORTING
        iv_name              TYPE sxco_cds_object_name
        iv_property          TYPE sxco_cds_ann_property
      RETURNING
        VALUE(ro_annotation) TYPE REF TO if_xco_cds_annotation.
ENDCLASS.

CLASS ltcl_annotation_values IMPLEMENTATION.
  METHOD pick.
    ro_annotation = xco_cds=>annotations->aggregated->of( xco_cds=>entity( iv_name ) )->pick( iv_property ).
    cl_abap_unit_assert=>assert_bound(
      act = ro_annotation
      msg = |{ iv_name } { iv_property }| ).
  ENDMETHOD.

  METHOD string_value.
    DATA lv_label TYPE string.

    pick(
      iv_name     = 'ZI_XCOT_ORDER'
      iv_property = 'EndUserText.label' )->get_value( )->write_to( REF #( lv_label ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_label
      exp = `XCO test order` ).
  ENDMETHOD.

  METHOD enum_value.
* the enum symbol without the leading #
    DATA lv_check TYPE string.

    pick(
      iv_name     = 'ZI_XCOT_ORDER'
      iv_property = 'AccessControl.authorizationCheck' )->get_value( )->write_to( REF #( lv_check ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_check
      exp = `NOT_REQUIRED` ).
  ENDMETHOD.

  METHOD boolean_value.
    DATA lv_compare TYPE abap_bool.

    pick(
      iv_name     = 'ZI_XCOT_ORDERVIEW'
      iv_property = 'AbapCatalog.compiler.compareFilter' )->get_value( )->write_to( REF #( lv_compare ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_compare
      exp = abap_true ).
  ENDMETHOD.

  METHOD array_value.
    DATA lt_categories TYPE string_table.

    pick(
      iv_name     = 'ZI_XCOT_ORDERVIEW'
      iv_property = 'AbapCatalog.viewEnhancementCategory' )->get_value( )->write_to( REF #( lt_categories ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_categories
      exp = VALUE string_table( ( `NONE` ) ) ).
  ENDMETHOD.

  METHOD object_value.
* components match the annotation elements by name, regardless of case
    TYPES:
      BEGIN OF ty_usage_type,
        servicequality TYPE string,
        sizecategory   TYPE string,
        dataclass      TYPE string,
      END OF ty_usage_type.
    DATA ls_usage_type TYPE ty_usage_type.

    pick(
      iv_name     = 'ZI_XCOT_ORDER'
      iv_property = 'ObjectModel.usageType' )->get_value( )->write_to( REF #( ls_usage_type ) ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_usage_type
      exp = VALUE ty_usage_type(
        servicequality = `A`
        sizecategory   = `S`
        dataclass      = `TRANSACTIONAL` ) ).
  ENDMETHOD.

  METHOD nested_path.
    DATA lv_size TYPE string.

    pick(
      iv_name     = 'ZI_XCOT_ORDER'
      iv_property = 'ObjectModel.usageType.sizeCategory' )->get_value( )->write_to( REF #( lv_size ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_size
      exp = `S` ).
  ENDMETHOD.

  METHOD absent.
    cl_abap_unit_assert=>assert_not_bound(
      xco_cds=>annotations->aggregated->of( xco_cds=>entity( 'ZI_XCOT_ORDER' ) )->pick( 'EndUserText.quickInfo' ) ).
  ENDMETHOD.

  METHOD field_annotation.
    DATA lv_label TYPE string.

    DATA(lt_fields) = xco_cds=>view_entity( 'ZI_XCOT_ORDER' )->fields->all->get( ).
    DATA(lo_description) = lt_fields[ 4 ].
    cl_abap_unit_assert=>assert_equals(
      act = to_upper( lo_description->name )
      exp = 'DESCRIPTION' ).

    DATA(lo_annotations) = xco_cds=>annotations->aggregated->of( lo_description ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_annotations->contain( 'EndUserText.label' )
      exp = abap_true ).
    lo_annotations->pick( 'EndUserText.label' )->get_value( )->write_to( REF #( lv_label ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_label
      exp = `Order text` ).

    cl_abap_unit_assert=>assert_equals(
      act = xco_cds=>annotations->aggregated->of( lt_fields[ 3 ] )->contain( 'EndUserText.label' )
      exp = abap_false ).
  ENDMETHOD.
ENDCLASS.
