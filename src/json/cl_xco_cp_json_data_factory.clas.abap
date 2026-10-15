CLASS cl_xco_cp_json_data_factory DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_json.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_json_data_factory.
ENDCLASS.

CLASS cl_xco_cp_json_data_factory IMPLEMENTATION.
  METHOD if_xco_cp_json_data_factory~builder.
    ro_builder = NEW lcl_json_data_builder( ).
  ENDMETHOD.

  METHOD if_xco_cp_json_data_factory~from_abap.
    ro_json_data = lcl_abap_to_json=>convert( ia_abap ).
  ENDMETHOD.

  METHOD if_xco_cp_json_data_factory~from_string.
    ro_json_data = lcl_json_parser=>parse( |{ iv_string }| ).
  ENDMETHOD.
ENDCLASS.
