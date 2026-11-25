# Anomalies: CDS and Dictionary regression tests

Open issues found by the regression tests in `src/cds/xco_cds.clas.testclasses.abap` and `src/abap_dictionary/xco_cp_abap_dictionary.clas.testclasses.abap`, which run against the synthetic fixtures in `test/fixtures/`.

Checked with `@abaplint/transpiler-cli` 2.14.38, `@abaplint/runtime` 2.14.38 and `@abaplint/cli` 2.120.118.

## 1. C1 release state

The transpiler emits no content for `APIS` objects. The fixture `zi_xcot_order.apis.json` (contract `c1`, state `released`) produces only a TADIR row, so neither the contract nor the state reaches the runtime.

`if_xco_cds_entity~get_api_state` therefore returns `not_released` when there is no `APIS` object. When one exists it raises `cx_xco_runtime_exception`, because the state is unknown.

`ltcl_entity->released_c1` is skipped through `options.skip` in `abap_transpile.json`. Remove the skip once the transpiler writes the APIS content and `get_api_state` reads it.

## 2. Transpiler runtime metadata gaps

1. **Annotation layers.** `cds.annotations` holds only the annotations written in the entity's own source. Metadata extensions (DDLX), annotations inherited from data sources and derived annotations are not available. As a result, `aggregated` returns the same as `direct`, while `inherited`, `derived` and `metadata_extension` return nothing.
2. **Hierarchy elements.** For `ZI_XCOT_HIERARCHY` the output has `definitionType: "HIERARCHY"`, but `fields: []`. The element list `{ NodeId, ParentId }` and the hierarchy source and association are not captured.
3. **Projection view row type.** `abap.DDIC["ZC_XCOT_ORDER"].type()` throws `Void type: DDLS:fieldname:ZC_XCOT_ORDER`, because projected element types are not resolved from the base entity.
4. **Domains.** `DOMA` gets no `abap.DDIC` entry. Apart from its TADIR row, a domain is visible only through `DTEL.domain` / `DTEL.fixedValues`. Its own data type, length and output attributes are not available.
5. **Data element built-in type.** A DTEL entry carries only the runtime ABAP type, not the DDIC `DATATYPE` / `LENG` / `DECIMALS`. CHAR, CLNT, LANG, CUKY and UNIT all map to `Character`, so `get_built_in_type( )->type` reports CHAR for all of them.
6. **DDLS description.** `description` comes from `@EndUserText.label`, not from `DDTEXT` in the `.ddls.xml`. `ZI_XCOT_HIERARCHY` has no label, so its description is `undefined`.

## 3. XCO methods still `todo`

- `if_xco_cds_annotations~pick`
- `if_xco_data_definition~check_syntax`, `get_state`
- generation methods on CDS entities: `add_annotation`, `add_association`, `add_composition`, `add_field`, `set_where`, `set_root`, `if_xco_printable~get_text`
- `content( )` on domains, structures and classes; `get_api_state( )` on domains; `set_api_state( )` on classes

## 4. Fixture details not verified against a real system

- **Name casing.** The case in which SAP returns field and association names is unknown. The tests compare `to_upper( )` values.
- **Custom entity.** It has no `@ObjectModel.query.implementedBy`, because the fixtures include no query provider class.
- **Table function.** `implemented by method zcl_xcot_marker=>get_rows` points to a method that does not exist. abaplint does not check this.
- **Interface reference REFTYPE.** The interface-reference TTYP uses `REFTYPE` `I`. abaplint ignores `REFTYPE`, so this value has not been checked against an export from a real system.
