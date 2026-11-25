CLASS cl_xco_ad_data_element DEFINITION PUBLIC FINAL CREATE PUBLIC.
* read access to a data element, the content and the data type are the same object
  PUBLIC SECTION.
    INTERFACES if_xco_ad_data_element.
    INTERFACES if_xco_dtel_content.
    INTERFACES if_xco_dtel_data_type.

    METHODS constructor
      IMPORTING
        iv_name TYPE csequence.

  PRIVATE SECTION.
    DATA mv_read TYPE abap_bool.
    DATA ms_data_element TYPE cl_xco_runtime_ddic=>ty_data_element.

    METHODS read
      RETURNING
        VALUE(rs_data_element) TYPE cl_xco_runtime_ddic=>ty_data_element.

    METHODS built_in_type
      RETURNING
        VALUE(ro_built_in_type) TYPE REF TO cl_xco_ad_built_in_type.
ENDCLASS.

CLASS cl_xco_ad_data_element IMPLEMENTATION.
  METHOD constructor.
    if_xco_ar_object~name = to_upper( condense( iv_name ) ).
  ENDMETHOD.

  METHOD read.
    IF mv_read = abap_false.
      ms_data_element = cl_xco_runtime_ddic=>data_element( if_xco_ar_object~name ).
      mv_read = abap_true.
    ENDIF.
    rs_data_element = ms_data_element.
  ENDMETHOD.

  METHOD built_in_type.
    DATA(ls_built_in) = read( )-built_in.
    IF ls_built_in-type IS NOT INITIAL.
      ro_built_in_type = NEW #(
        iv_type     = ls_built_in-type
        iv_length   = ls_built_in-length
        iv_decimals = ls_built_in-decimals ).
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_ar_object~exists.
    rv_exists = read( )-found.
  ENDMETHOD.

  METHOD if_xco_ar_object~get_namespace.
    rv_namespace = cl_xco_runtime_ddic=>namespace( if_xco_ar_object~name ).
  ENDMETHOD.

  METHOD if_xco_ar_object~get_package.
    CLEAR ro_package.
  ENDMETHOD.

  METHOD if_xco_ar_object~get_original_language.
    CLEAR ro_original_language.
  ENDMETHOD.

  METHOD if_xco_ar_object~get_state.
    CLEAR ro_state.
  ENDMETHOD.

  METHOD if_xco_ad_data_element~content.
    ro_content = me.
  ENDMETHOD.

  METHOD if_xco_dtel_content~get.
    rs_data_element-data_type = me.
  ENDMETHOD.

  METHOD if_xco_dtel_content~get_data_type.
    ro_data_type = me.
  ENDMETHOD.

  METHOD if_xco_dtel_content~has_underlying_built_in_type.
* via the domain or directly, a reference type has none
    rv_result = xsdbool( read( )-built_in-type IS NOT INITIAL ).
  ENDMETHOD.

  METHOD if_xco_dtel_content~get_underlying_built_in_type.
    ro_built_in_type = built_in_type( ).
  ENDMETHOD.

  METHOD if_xco_dtel_data_type~is_domain.
    rv_result = xsdbool( read( )-domain IS NOT INITIAL ).
  ENDMETHOD.

  METHOD if_xco_dtel_data_type~is_built_in_type.
    DATA(ls_data_element) = read( ).
    rv_result = xsdbool( ls_data_element-domain IS INITIAL AND ls_data_element-built_in-type IS NOT INITIAL ).
  ENDMETHOD.

  METHOD if_xco_dtel_data_type~get_domain.
    DATA(lv_domain) = read( )-domain.
    IF lv_domain IS NOT INITIAL.
      ro_domain = NEW cl_xco_ad_domain( lv_domain ).
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_dtel_data_type~get_built_in_type.
    IF if_xco_dtel_data_type~is_built_in_type( ) = abap_true.
      ro_built_in_type = built_in_type( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
