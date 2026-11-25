CLASS cl_xco_cds_field DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cds_field.
    INTERFACES if_xco_cds_field_content.

    METHODS constructor
      IMPORTING
        is_field TYPE cl_xco_runtime_ddic=>ty_cds_field.

    METHODS get_annotations
      RETURNING
        VALUE(rt_annotations) TYPE cl_xco_runtime_ddic=>ty_annotations.

  PRIVATE SECTION.
    DATA ms_field TYPE cl_xco_runtime_ddic=>ty_cds_field.
ENDCLASS.

CLASS cl_xco_cds_field IMPLEMENTATION.
  METHOD constructor.
    ms_field = is_field.
    if_xco_cds_field~name = is_field-name.
  ENDMETHOD.

  METHOD get_annotations.
    rt_annotations = ms_field-annotations.
  ENDMETHOD.

  METHOD if_xco_cds_field~content.
    ro_content = me.
  ENDMETHOD.

  METHOD if_xco_cds_field_content~get_key_indicator.
    rv_key_indicator = ms_field-key_indicator.
  ENDMETHOD.

  METHOD if_xco_cds_field_content~get.
    rs_content-alias = ms_field-name.
    rs_content-key_indicator = ms_field-key_indicator.
  ENDMETHOD.

  METHOD if_xco_cds_field_content~get_type.
    CLEAR ro_type.
  ENDMETHOD.
ENDCLASS.
