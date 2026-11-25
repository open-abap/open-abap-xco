CLASS cl_xco_ad_structure_component DEFINITION PUBLIC FINAL CREATE PUBLIC.
* a structure component, the content is the same object
  PUBLIC SECTION.
    INTERFACES if_xco_ad_structure_component.
    INTERFACES if_xco_ad_structure_comp_ct.

    METHODS constructor
      IMPORTING
        is_component TYPE cl_xco_runtime_ddic=>ty_structure_component.

  PRIVATE SECTION.
    DATA ms_component TYPE cl_xco_runtime_ddic=>ty_structure_component.
ENDCLASS.

CLASS cl_xco_ad_structure_component IMPLEMENTATION.
  METHOD constructor.
    ms_component = is_component.
    if_xco_ad_structure_component~name = is_component-name.
  ENDMETHOD.

  METHOD if_xco_ad_structure_component~content.
    ro_content = me.
  ENDMETHOD.

  METHOD if_xco_ad_structure_comp_ct~get.
* the reference field of currency and quantity components is not available at runtime
    rs_content-type = if_xco_ad_structure_comp_ct~get_type( ).
  ENDMETHOD.

  METHOD if_xco_ad_structure_comp_ct~get_type.
* unbound for components that are neither typed with a data element nor elementary
    IF ms_component-data_element IS NOT INITIAL OR ms_component-built_in-type IS NOT INITIAL.
      ro_type = NEW cl_xco_ad_field_type(
        iv_data_element = ms_component-data_element
        is_built_in     = ms_component-built_in ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
