# Anomalies: CDS and Dictionary regression tests

The regression tests in `src/cds/xco_cds.clas.testclasses.abap` and `src/abap_dictionary/xco_cp_abap_dictionary.clas.testclasses.abap`, run against the synthetic fixtures in `test/fixtures/` (`ZXCOT_*`, `ZI_/ZC_/ZD_/ZF_XCOT_*`), found the gaps below.

Status on 2026-11-25, with `@abaplint/transpiler-cli` 2.14.38, `@abaplint/runtime` 2.14.38 and `@abaplint/cli` 2.120.118:

- abaplint: 0 issues.
- Every pre-existing test still passes (232 of 232).
- All **44 new tests fail**. Every failure comes from section 1: the transpiler output for the fixtures is present and correct, except for the gaps in section 2.

## 1. XCO implementation missing (this repository)

Each API the tests call is either a stub or never initialized:

| API | Location | Failure |
|---|---|---|
| `xco_cds=>data_definition / entity / view / view_entity` (and all other `xco_cds` / `xco_cp_cds` methods) | `src/cds/xco_cds.clas.abap:78-96` | `ASSERT 1 = 'todo'` raises `CONVT_NO_NUMBER` |
| `xco_cds=>annotations`, holds `aggregated` | `src/cds/xco_cds.clas.abap:8` | never instantiated |
| `cl_xco_cds_ann_class->of` | `src/cds/cl_xco_cds_ann_class.clas.abap:13` | `todo` |
| `xco_cp_data_definition=>type`, holds `view`, `view_entity`, `projection_view`, `abstract_entity`, `custom_entity`, `table_function`, `hierarchy` | `src/cds/xco_cp_data_definition.clas.abap:3` | never instantiated |
| `xco_cp_ars=>release_contract->c1`, `xco_cp_ars=>release_state->released / not_released` | `src/ars/xco_cp_ars.clas.abap:3-4` | never instantiated |
| `cl_xco_ars_api_state->get_release_state` | `src/ars/cl_xco_ars_api_state.clas.abap:14` | `todo` |
| `xco_cp_abap_dictionary=>data_element / table_type` | `src/abap_dictionary/xco_cp_abap_dictionary.clas.abap:41-46` | `todo` |
| `xco_abap_dictionary=>data_element / table_type` | `src/abap_dictionary/xco_abap_dictionary.clas.abap:17-22` | `todo` |

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

- **The unit runner stops at the first failure.** `output/index.mjs` exits on the first failing method. With these tests in place, `npm run unit` stops at `XCO_CDS ltcl_data_definition->existing`, so pre-existing tests that sort after it (`XCO_CP_ABAP_DICTIONARY`, `XCO_CP_CALL_STACK`, `XCO_CP_TIME`, `XCO_CP_XLSX`) do not run. CI stays red until section 1 is implemented, unless the new classes are listed under the transpiler's `options.skip`.
- **Fixtures are outside `src/`.** They live in `test/fixtures/`, which `abaplint.jsonc` (`global.files`) and `abap_transpile.json` (`input_folder`) both include. Projects that depend on open-abap-xco through `/src/**` therefore do not load them.
