# Anomalies: CDS and Dictionary regression tests

The regression tests in `src/cds/xco_cds.clas.testclasses.abap` and `src/abap_dictionary/xco_cp_abap_dictionary.clas.testclasses.abap`, run against the synthetic fixtures in `test/fixtures/` (`ZXCOT_*`, `ZI_/ZC_/ZD_/ZF_XCOT_*`), found the gaps below.

Status on 2026-11-25, with `@abaplint/transpiler-cli` 2.14.38, `@abaplint/runtime` 2.14.38 and `@abaplint/cli` 2.120.118:

- abaplint: 0 issues.
- Run one method at a time, **275 of 276 tests pass**, including every pre-existing test. The one failure is `ltcl_entity->released_c1`, see section 1.
- `npm test` passes, with `released_c1` skipped in `abap_transpile.json`.

## 1. Open: C1 release state

The XCO APIs read the transpiler's runtime metadata (`abap.DDIC` and TADIR) through `src/core/cl_xco_runtime_ddic.clas.abap`. The one exception is the API release state, because the transpiler writes no content for `APIS` objects (section 2.1).

`if_xco_cds_entity~get_api_state` therefore behaves as follows:

- **No `APIS` object in TADIR:** it returns `not_released`. This is correct, because without an APIS object nothing is released.
- **An `APIS` object exists:** it raises `cx_xco_runtime_exception`, because the contract and state are unknown. Answering `not_released` would be silently wrong.

`released_c1` passes once the transpiler writes the APIS content, for example as `abap.DDIC` entries or rows in a release-state table, and `get_api_state` reads it.

Implementation notes that affect results:

- **Annotations.** `aggregated` and `direct` both return the annotations written in the entity's own source; `inherited`, `derived` and `metadata_extension` return none (section 2.2). `contain( )` ignores case, and also matches nested paths of structured values, for example `ObjectModel.usageType.serviceQuality`. `pick( )` is still `todo`.
- **Typed handles.** `xco_cds=>view / view_entity / projection_view / abstract_entity / custom_entity / table_function( )->exists( )` is only true if the DDLS has that definition type. `xco_cds=>entity( )` accepts any type.
- **Associations.** `associations->all->get( )` lists the exposed associations, in declaration order, without compositions. `compositions->all->get( )` lists the compositions.
- **Data elements.** The built-in type is derived from the runtime type (section 2.6).
- **Domains and repository objects.** Domains, classes and interfaces are checked against TADIR. Their content (`content( )`, `get_api_state( )`) is still `todo`.

## 2. Transpiler runtime metadata gaps

The tests assert the following behaviour, but `abap.DDIC` / `init.mjs` does not provide the data needed to implement it:

1. **API release state (C1).** The `APIS` fixture `zi_xcot_order.apis.json` (contract `c1`, state `released`) produces only a TADIR row. Neither the contract nor the state reaches the runtime. As a result, `get_api_state( c1 )->get_release_state( )` cannot tell released from not released.
2. **Aggregated annotations.** `cds.annotations` holds only the annotations written in the entity's own source. Metadata extensions (DDLX), inheritance from data sources and derived annotations are not merged. In this harness "aggregated" therefore behaves like "direct", and the tests only cover directly written annotations. Structured values keep their path: `@ObjectModel.usageType: { ... }` becomes a single annotation named `ObjectModel.usageType` with an object value. Whether `contain( 'ObjectModel.usageType.serviceQuality' )` is true is therefore up to the XCO implementation.
3. **Hierarchy elements.** For `ZI_XCOT_HIERARCHY` the output is `definitionType: "HIERARCHY"`, but `fields: []`. The element list `{ NodeId, ParentId }` and the hierarchy source/association are not captured.
4. **Projection view row type.** `abap.DDIC["ZC_XCOT_ORDER"].type()` throws `Void type: DDLS:fieldname:ZC_XCOT_ORDER`, because projected element types are not resolved from the base entity. The `cds` block (fields, keys, inherited association `_Status`) is correct.
5. **Domains.** `DOMA` gets no `abap.DDIC` entry. A domain is visible only through `DTEL.domain` / `DTEL.fixedValues`, plus its TADIR row. The domain's own data type, length and output attributes are not available.
6. **Data element built-in type.** A DTEL entry carries only the runtime ABAP type, not the DDIC `DATATYPE` / `LENG` / `DECIMALS`. CHAR, CLNT, LANG, CUKY and UNIT all map to `Character`, so `get_built_in_type( )->type` can only be guessed. For the fixture's CHAR 40 the guess happens to be right.
7. **Table type row kind.** A TTYP entry has `type` and `description` only, with no `ROWKIND` / `ROWTYPE`. The row kind and referenced name can be read from the type object:
   - data element: `qualifiedName` / `ddicName`
   - nested table type: the `TableFactory` name
   - class or interface: `RTTIName` `\CLASS=` or `\INTERFACE=`
   - structure: the structure's qualified name

   A row typed with a data element and a row with a predefined type (`ROWKIND` empty) differ only in whether `ddicName` is present.
8. **DDLS description.** `description` comes from `@EndUserText.label`, not from `DDTEXT` in the `.ddls.xml`. `ZI_XCOT_HIERARCHY` has no label, so its description is `undefined`.

## 3. Behaviour the fixtures cannot express

- **Key fields after non-key fields.** This order is invalid CDS and is rejected by the `cds_field_order` lint rule. The ordering tests instead pick names whose alphabetical order differs from declaration order, for both fields (`DESCRIPTION` sorts first but is declared last, and is a non-key field) and associations (`_Status` is declared before `_Node`).
- **Name casing.** The case in which XCO returns field and association names is not pinned. Tests compare `to_upper( )` values and check content and order only.
- **Custom entity.** It has no `@ObjectModel.query.implementedBy`, because the fixtures include no query provider class.
- **Table function.** `implemented by method zcl_xcot_marker=>get_rows` points to a method that does not exist. abaplint does not check this, and AMDP is not executable in this harness anyway; only the definition type matters to the tests.
- **Interface reference REFTYPE.** The interface-reference TTYP uses `REFTYPE` `I`. abaplint ignores `REFTYPE`, so this value has not been checked against a real system export.

## 4. Harness notes

- **`released_c1` is skipped.** It is listed under `options.skip` in `abap_transpile.json`, so `npm test` passes and reports it as "skipped due to configuration". Remove the entry once section 1 is resolved. Note that `output/index.mjs` stops at the first failing method, so an unskipped failure hides every test that sorts after it.
- **Fixtures are outside `src/`.** They live in `test/fixtures/`, which `abaplint.jsonc` (`global.files`) and `abap_transpile.json` (`input_folder`) both include. Projects that depend on open-abap-xco through `/src/**` therefore do not load them.
