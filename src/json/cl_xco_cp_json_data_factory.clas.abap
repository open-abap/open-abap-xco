CLASS cl_xco_cp_json_data_factory DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_json_data_factory.
ENDCLASS.

CLASS cl_xco_cp_json_data_factory IMPLEMENTATION.
  METHOD if_xco_cp_json_data_factory~builder.
    ro_builder = NEW lcl_json_data_builder( ).
  ENDMETHOD.

  METHOD if_xco_cp_json_data_factory~from_abap.
    DATA(lv_json) = /ui2/cl_json=>serialize( ia_abap ).

    ro_json_data = NEW lcl_json_data( lv_json ).
  ENDMETHOD.

  METHOD if_xco_cp_json_data_factory~from_string.
    ro_data = NEW lcl_json_data( iv_string ).
  ENDMETHOD.
ENDCLASS.
