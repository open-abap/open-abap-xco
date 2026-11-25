CLASS cl_xco_runtime_ddic DEFINITION PUBLIC FINAL CREATE PRIVATE.
* open-abap internal: reads the DDIC and CDS metadata the transpiler writes to abap.DDIC
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_cds_field,
        name          TYPE string,
        key_indicator TYPE abap_bool,
        annotations   TYPE string_table,
      END OF ty_cds_field,
      ty_cds_fields TYPE STANDARD TABLE OF ty_cds_field WITH DEFAULT KEY,
      BEGIN OF ty_cds_association,
        name        TYPE string,
        target      TYPE string,
* ASSOCIATION, COMPOSITION or TO_PARENT
        kind        TYPE string,
        exposed     TYPE abap_bool,
        annotations TYPE string_table,
      END OF ty_cds_association,
      ty_cds_associations TYPE STANDARD TABLE OF ty_cds_association WITH DEFAULT KEY,
      BEGIN OF ty_cds,
        found           TYPE abap_bool,
* VIEW, VIEW_ENTITY, PROJECTION_VIEW, ABSTRACT_ENTITY, CUSTOM_ENTITY, TABLE_FUNCTION, HIERARCHY, ...
        definition_type TYPE string,
        annotations     TYPE string_table,
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
* "ObjectModel.usageType: { serviceQuality: #A }" gives ObjectModel.usageType and ObjectModel.usageType.serviceQuality
    DATA lv_name TYPE string.
    DATA lv_annotation TYPE string.
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
    WRITE '@KERNEL const flat = (list) => {'.
    WRITE '@KERNEL   const ret = [];'.
    WRITE '@KERNEL   const walk = (path, value) => {'.
    WRITE '@KERNEL     ret.push(path);'.
    WRITE '@KERNEL     if (value === null || typeof value !== "object" || Array.isArray(value)) { return; }'.
    WRITE '@KERNEL     for (const k of Object.keys(value).filter(k => !k.startsWith("#"))) { walk(path + "." + k, value[k]); }'.
    WRITE '@KERNEL   };'.
    WRITE '@KERNEL   for (const a of list || []) { walk(a.name, a.value); }'.
    WRITE '@KERNEL   return ret;'.
    WRITE '@KERNEL };'.
    WRITE '@KERNEL for (const a of flat(cds.annotations)) {'.
    WRITE '@KERNEL   lv_annotation.set(a);'.
    APPEND lv_annotation TO rs_cds-annotations.
    WRITE '@KERNEL }'.

    WRITE '@KERNEL for (const f of cds.fields || []) {'.
    CLEAR ls_field.
    WRITE '@KERNEL   ls_field.get().name.set(f.name);'.
    WRITE '@KERNEL   ls_field.get().key_indicator.set(f.key ? "X" : "");'.
    WRITE '@KERNEL   for (const a of flat(f.annotations)) {'.
    WRITE '@KERNEL     lv_annotation.set(a);'.
    APPEND lv_annotation TO ls_field-annotations.
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
    WRITE '@KERNEL     lv_annotation.set(n);'.
    APPEND lv_annotation TO ls_association-annotations.
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
    DATA lv_name TYPE string.

    IF object_type( iv_name ) <> 'TTYP'.
      RETURN.
    ENDIF.
    lv_name = to_upper( condense( iv_name ) ).
    rs_table_type-found = abap_true.

    WRITE '@KERNEL const meta = abap.DDIC[lv_name.get()];'.
    WRITE '@KERNEL rs_table_type.get().description.set(meta.description || "");'.
    WRITE '@KERNEL const row = meta.type().getRowType();'.
    WRITE '@KERNEL const setRow = (kind, name) => {'.
    WRITE '@KERNEL   rs_table_type.get().row_kind.set(kind);'.
    WRITE '@KERNEL   rs_table_type.get().row_name.set((name || "").toUpperCase()); };'.
    WRITE '@KERNEL const rtti = typeof row.getRTTIName === "function" ? row.getRTTIName() || "" : "";'.
    WRITE '@KERNEL const ddic = typeof row.getDDICName === "function" ? row.getDDICName() : undefined;'.
    WRITE '@KERNEL if (typeof row.getRowType === "function") { setRow("TABLE_TYPE", row.getQualifiedName()); }'.
    WRITE '@KERNEL else if (rtti.startsWith("\\CLASS=")) { setRow("CLASS", rtti.substring(7)); }'.
    WRITE '@KERNEL else if (rtti.startsWith("\\INTERFACE=")) { setRow("INTERFACE", rtti.substring(11)); }'.
    WRITE '@KERNEL else if (row instanceof abap.types.Structure) { setRow("STRUCTURE", ddic || row.getQualifiedName()); }'.
    WRITE '@KERNEL else if (row instanceof abap.types.DataReference) { setRow("REFERENCE", ""); }'.
    WRITE '@KERNEL else if (ddic && abap.DDIC[ddic.toUpperCase()]?.objectType === "DTEL") { setRow("DATA_ELEMENT", ddic); }'.
    WRITE '@KERNEL else { setRow("BUILT_IN", ""); }'.
  ENDMETHOD.
ENDCLASS.
