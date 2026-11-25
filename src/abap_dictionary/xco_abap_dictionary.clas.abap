CLASS xco_abap_dictionary DEFINITION PUBLIC.
  PUBLIC SECTION.

    CLASS-DATA built_in_type TYPE REF TO cl_xco_ad_built_in_type_f READ-ONLY.
    CLASS-DATA object_read_state TYPE REF TO cl_xco_ad_object_read_state_f READ-ONLY.
    CLASS-DATA object_state TYPE REF TO cl_xco_ad_object_state_f READ-ONLY.

    CLASS-METHODS data_element
      IMPORTING iv_name        TYPE sxco_ad_object_name
      RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_data_element.
    CLASS-METHODS table_type
      IMPORTING iv_name        TYPE sxco_ad_object_name
      RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_table_type.
ENDCLASS.

CLASS xco_abap_dictionary IMPLEMENTATION.
  METHOD data_element.
    ro_type = xco_cp_abap_dictionary=>data_element( iv_name ).
  ENDMETHOD.

  METHOD table_type.
    ro_type = xco_cp_abap_dictionary=>table_type( iv_name ).
  ENDMETHOD.
ENDCLASS.
