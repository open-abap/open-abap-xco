CLASS cl_xco_cp_json_trnsfrmtn_fctry DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_json.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_json_trnsfrmtn_fctry.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_json_trnsfrmtn_fctry IMPLEMENTATION.
  METHOD constructor.
    if_xco_cp_json_trnsfrmtn_fctry~camel_case_to_underscore = NEW lcl_transformation(
      lcl_transformation=>gc_kind-camel_case_to_underscore ).
    if_xco_cp_json_trnsfrmtn_fctry~pascal_case_to_underscore = NEW lcl_transformation(
      lcl_transformation=>gc_kind-pascal_case_to_underscore ).
    if_xco_cp_json_trnsfrmtn_fctry~underscore_to_camel_case = NEW lcl_transformation(
      lcl_transformation=>gc_kind-underscore_to_camel_case ).
    if_xco_cp_json_trnsfrmtn_fctry~underscore_to_pascal_case = NEW lcl_transformation(
      lcl_transformation=>gc_kind-underscore_to_pascal_case ).
    if_xco_cp_json_trnsfrmtn_fctry~boolean_to_abap_bool = NEW lcl_transformation(
      lcl_transformation=>gc_kind-boolean_to_abap_bool ).
  ENDMETHOD.

  METHOD if_xco_cp_json_trnsfrmtn_fctry~name_replacement.
    ro_name_replacement = NEW lcl_transformation(
      iv_kind         = lcl_transformation=>gc_kind-name_replacement
      it_name_mapping = it_name_mapping ).
  ENDMETHOD.
ENDCLASS.
