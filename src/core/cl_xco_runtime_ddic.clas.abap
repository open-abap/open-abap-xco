CLASS cl_xco_runtime_ddic DEFINITION PUBLIC FINAL CREATE PRIVATE.
* open-abap internal: reads the DDIC and CDS metadata the transpiler writes to abap.DDIC
  PUBLIC SECTION.
    TYPES:
* value: the annotation value as JSON, enums without "#", booleans as "X" or "", object keys in upper case
      BEGIN OF ty_annotation,
        name  TYPE string,
        value TYPE string,
      END OF ty_annotation,
      ty_annotations TYPE STANDARD TABLE OF ty_annotation WITH DEFAULT KEY,
      BEGIN OF ty_cds_field,
        name          TYPE string,
        key_indicator TYPE abap_bool,
        annotations   TYPE ty_annotations,
      END OF ty_cds_field,
      ty_cds_fields TYPE STANDARD TABLE OF ty_cds_field WITH DEFAULT KEY,
      BEGIN OF ty_cds_association,
        name        TYPE string,
        target      TYPE string,
* ASSOCIATION, COMPOSITION or TO_PARENT
        kind        TYPE string,
        exposed     TYPE abap_bool,
        annotations TYPE ty_annotations,
      END OF ty_cds_association,
      ty_cds_associations TYPE STANDARD TABLE OF ty_cds_association WITH DEFAULT KEY,
      BEGIN OF ty_cds,
        found           TYPE abap_bool,
* VIEW, VIEW_ENTITY, PROJECTION_VIEW, ABSTRACT_ENTITY, CUSTOM_ENTITY, TABLE_FUNCTION, HIERARCHY, ...
        definition_type TYPE string,
        annotations     TYPE ty_annotations,
        fields          TYPE ty_cds_fields,
        associations    TYPE ty_cds_associations,
      END OF ty_cds,
      BEGIN OF ty_built_in_type,
        type     TYPE string,
        length   TYPE i,
        decimals TYPE i,
      END OF ty_built_in_type,
      BEGIN OF ty_data_element,
        found    TYPE abap_bool,
        domain   TYPE string,
        built_in TYPE ty_built_in_type,
      END OF ty_data_element,
      BEGIN OF ty_table_type,
        found       TYPE abap_bool,
        description TYPE string,
* DATA_ELEMENT, STRUCTURE, TABLE_TYPE, INTERFACE, CLASS, REFERENCE or BUILT_IN
        row_kind    TYPE string,
        row_name    TYPE string,
      END OF ty_table_type.

    CLASS-METHODS object_type
      IMPORTING
        iv_name        TYPE csequence
      RETURNING
        VALUE(rv_type) TYPE string.

    CLASS-METHODS tadir_exists
      IMPORTING
        iv_object        TYPE csequence
        iv_name          TYPE csequence
      RETURNING
        VALUE(rv_exists) TYPE abap_bool.

    CLASS-METHODS namespace
      IMPORTING
        iv_name             TYPE csequence
      RETURNING
        VALUE(rv_namespace) TYPE if_xco_ar_object=>tv_namespace.

    CLASS-METHODS cds
      IMPORTING
        iv_name       TYPE csequence
      RETURNING
        VALUE(rs_cds) TYPE ty_cds.

    CLASS-METHODS data_element
      IMPORTING
        iv_name                TYPE csequence
      RETURNING
        VALUE(rs_data_element) TYPE ty_data_element.

    CLASS-METHODS table_type
      IMPORTING
        iv_name              TYPE csequence
      RETURNING
        VALUE(rs_table_type) TYPE ty_table_type.

ENDCLASS.

CLASS cl_xco_runtime_ddic IMPLEMENTATION.
  METHOD object_type.
    DATA lv_name TYPE string.

    lv_name = to_upper( condense( iv_name ) ).
    WRITE '@KERNEL rv_type.set(abap.DDIC[lv_name.get()]?.objectType || "");'.
  ENDMETHOD.

  METHOD tadir_exists.
    DATA lv_object TYPE tadir-object.
    DATA lv_name TYPE tadir-obj_name.

    lv_object = to_upper( iv_object ).
    lv_name = to_upper( iv_name ).
    SELECT SINGLE obj_name FROM tadir INTO @DATA(lv_found)
      WHERE pgmid = 'R3TR' AND object = @lv_object AND obj_name = @lv_name.
    rv_exists = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD namespace.
    FIND REGEX '^(/[^/]+/)' IN iv_name SUBMATCHES rv_namespace.
    IF sy-subrc <> 0.
      CLEAR rv_namespace.
    ENDIF.
  ENDMETHOD.

  METHOD cds.
* annotations are listed by their written name and, for structured values, by every nested path,
* "ObjectModel.usageType: { serviceQuality: #A }" gives ObjectModel.usageType {"SERVICEQUALITY":"A"}
* and ObjectModel.usageType.serviceQuality "A"
    DATA lv_name TYPE string.
    DATA ls_annotation TYPE ty_annotation.
    DATA ls_field LIKE LINE OF rs_cds-fields.
    DATA ls_association LIKE LINE OF rs_cds-associations.

    IF object_type( iv_name ) <> 'DDLS'.
      RETURN.
    ENDIF.
    lv_name = to_upper( condense( iv_name ) ).

    WRITE '@KERNEL const cds = abap.DDIC[lv_name.get()].cds;'.
    WRITE '@KERNEL if (cds) {'.
    rs_cds-found = abap_true.
    WRITE '@KERNEL rs_cds.get().definition_type.set(cds.definitionType || "");'.
    WRITE '@KERNEL const isRecord = (v) => v !== null && typeof v === "object" && !Array.isArray(v);'.
    WRITE '@KERNEL const norm = (v) => {'.
    WRITE '@KERNEL   if (typeof v === "boolean") { return v ? "X" : ""; }'.
    WRITE '@KERNEL   if (Array.isArray(v)) { return v.map(norm); }'.
    WRITE '@KERNEL   if (!isRecord(v)) { return v; }'.
    WRITE '@KERNEL   if ("#" in v) { return v["#"]; }'.
    WRITE '@KERNEL   if ("#()" in v) { return v["#()"]; }'.
    WRITE '@KERNEL   const ret = {};'.
    WRITE '@KERNEL   for (const k of Object.keys(v)) { ret[k.toUpperCase()] = norm(v[k]); }'.
    WRITE '@KERNEL   return ret;'.
    WRITE '@KERNEL };'.
    WRITE '@KERNEL const flat = (list) => {'.
    WRITE '@KERNEL   const ret = [];'.
    WRITE '@KERNEL   const walk = (path, value) => {'.
    WRITE '@KERNEL     ret.push({name: path, value: JSON.stringify(norm(value))});'.
    WRITE '@KERNEL     if (!isRecord(value) || "#" in value || "#()" in value) { return; }'.
    WRITE '@KERNEL     for (const k of Object.keys(value)) { walk(path + "." + k, value[k]); }'.
    WRITE '@KERNEL   };'.
    WRITE '@KERNEL   for (const a of list || []) { walk(a.name, a.value); }'.
    WRITE '@KERNEL   return ret;'.
    WRITE '@KERNEL };'.
    WRITE '@KERNEL for (const a of flat(cds.annotations)) {'.
    WRITE '@KERNEL   ls_annotation.get().name.set(a.name);'.
    WRITE '@KERNEL   ls_annotation.get().value.set(a.value);'.
    APPEND ls_annotation TO rs_cds-annotations.
    WRITE '@KERNEL }'.

    WRITE '@KERNEL for (const f of cds.fields || []) {'.
    CLEAR ls_field.
    WRITE '@KERNEL   ls_field.get().name.set(f.name);'.
    WRITE '@KERNEL   ls_field.get().key_indicator.set(f.key ? "X" : "");'.
    WRITE '@KERNEL   for (const a of flat(f.annotations)) {'.
    WRITE '@KERNEL     ls_annotation.get().name.set(a.name);'.
    WRITE '@KERNEL     ls_annotation.get().value.set(a.value);'.
    APPEND ls_annotation TO ls_field-annotations.
    WRITE '@KERNEL   }'.
    APPEND ls_field TO rs_cds-fields.
    WRITE '@KERNEL }'.

    WRITE '@KERNEL for (const a of cds.associations || []) {'.
    CLEAR ls_association.
    WRITE '@KERNEL   ls_association.get().name.set(a.name);'.
    WRITE '@KERNEL   ls_association.get().target.set((a.target || "").toUpperCase());'.
    WRITE '@KERNEL   ls_association.get().kind.set(a.type || "");'.
    WRITE '@KERNEL   ls_association.get().exposed.set(a.exposed ? "X" : "");'.
    WRITE '@KERNEL   for (const n of flat(a.annotations)) {'.
    WRITE '@KERNEL     ls_annotation.get().name.set(n.name);'.
    WRITE '@KERNEL     ls_annotation.get().value.set(n.value);'.
    APPEND ls_annotation TO ls_association-annotations.
    WRITE '@KERNEL   }'.
    APPEND ls_association TO rs_cds-associations.
    WRITE '@KERNEL }'.
    WRITE '@KERNEL }'.
  ENDMETHOD.

  METHOD data_element.
* via RTTI, a DDIC type of kind elementary or reference is a data element, a reference type has no built-in type
    DATA lo_type TYPE REF TO cl_abap_typedescr.
    DATA lo_element TYPE REF TO cl_abap_elemdescr.
    DATA ls_dfies TYPE dfies.

    cl_abap_typedescr=>describe_by_name(
      EXPORTING
        p_name         = to_upper( condense( iv_name ) )
      RECEIVING
        p_descr_ref    = lo_type
      EXCEPTIONS
        type_not_found = 1
        OTHERS         = 2 ).
    IF sy-subrc <> 0
        OR lo_type->is_ddic_type( ) = abap_false
        OR ( lo_type->kind <> cl_abap_typedescr=>kind_elem AND lo_type->kind <> cl_abap_typedescr=>kind_ref ).
      RETURN.
    ENDIF.
    rs_data_element-found = abap_true.

    IF lo_type->kind <> cl_abap_typedescr=>kind_elem.
      RETURN.
    ENDIF.
    lo_element ?= lo_type.
    lo_element->get_ddic_field(
      RECEIVING
        p_flddescr   = ls_dfies
      EXCEPTIONS
        not_found    = 1
        no_ddic_type = 2
        OTHERS       = 3 ).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    rs_data_element-domain = ls_dfies-domname.
    rs_data_element-built_in-type = ls_dfies-datatype.
    rs_data_element-built_in-length = ls_dfies-leng.
    rs_data_element-built_in-decimals = ls_dfies-decimals.
  ENDMETHOD.

  METHOD table_type.
* the row kind and name via RTTI, a DDIC row type is a data element, structure or table type
    DATA lv_name TYPE string.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
    DATA lo_table TYPE REF TO cl_abap_tabledescr.
    DATA lo_line TYPE REF TO cl_abap_datadescr.
    DATA lo_reference TYPE REF TO cl_abap_refdescr.
    DATA lo_referenced TYPE REF TO cl_abap_typedescr.

    lv_name = to_upper( condense( iv_name ) ).
    cl_abap_typedescr=>describe_by_name(
      EXPORTING
        p_name         = lv_name
      RECEIVING
        p_descr_ref    = lo_type
      EXCEPTIONS
        type_not_found = 1
        OTHERS         = 2 ).
    IF sy-subrc <> 0 OR lo_type->kind <> cl_abap_typedescr=>kind_table OR lo_type->is_ddic_type( ) = abap_false.
      RETURN.
    ENDIF.
    rs_table_type-found = abap_true.

* RTTI has no description
    WRITE '@KERNEL rs_table_type.get().description.set(abap.DDIC[lv_name.get()]?.description || "");'.

    lo_table ?= lo_type.
    lo_line = lo_table->get_table_line_type( ).
    CASE lo_line->kind.
      WHEN cl_abap_typedescr=>kind_table.
        rs_table_type-row_kind = 'TABLE_TYPE'.
        rs_table_type-row_name = lo_line->get_relative_name( ).
      WHEN cl_abap_typedescr=>kind_struct.
        rs_table_type-row_kind = 'STRUCTURE'.
        rs_table_type-row_name = lo_line->get_relative_name( ).
      WHEN cl_abap_typedescr=>kind_ref.
        lo_reference ?= lo_line.
        lo_referenced = lo_reference->get_referenced_type( ).
        CASE lo_referenced->kind.
          WHEN cl_abap_typedescr=>kind_class.
            rs_table_type-row_kind = 'CLASS'.
            rs_table_type-row_name = lo_referenced->get_relative_name( ).
          WHEN cl_abap_typedescr=>kind_intf.
            rs_table_type-row_kind = 'INTERFACE'.
            rs_table_type-row_name = lo_referenced->get_relative_name( ).
          WHEN OTHERS.
            rs_table_type-row_kind = 'REFERENCE'.
        ENDCASE.
      WHEN OTHERS.
        IF lo_line->is_ddic_type( ) = abap_true.
          rs_table_type-row_kind = 'DATA_ELEMENT'.
          rs_table_type-row_name = lo_line->get_relative_name( ).
        ELSE.
          rs_table_type-row_kind = 'BUILT_IN'.
        ENDIF.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
