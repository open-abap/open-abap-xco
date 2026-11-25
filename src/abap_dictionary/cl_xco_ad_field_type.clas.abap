CLASS cl_xco_ad_field_type DEFINITION PUBLIC FINAL CREATE PUBLIC.
* the type of a field: a data element, or else a built-in type
  PUBLIC SECTION.
    INTERFACES if_xco_ad_field_type.

    METHODS constructor
      IMPORTING
        iv_data_element TYPE string
        is_built_in     TYPE cl_xco_runtime_ddic=>ty_built_in_type.

  PRIVATE SECTION.
    DATA mv_data_element TYPE string.
    DATA ms_built_in TYPE cl_xco_runtime_ddic=>ty_built_in_type.
ENDCLASS.

CLASS cl_xco_ad_field_type IMPLEMENTATION.
  METHOD constructor.
    mv_data_element = iv_data_element.
    ms_built_in = is_built_in.
  ENDMETHOD.

  METHOD if_xco_ad_field_type~is_data_element.
    rv_result = xsdbool( mv_data_element IS NOT INITIAL ).
  ENDMETHOD.

  METHOD if_xco_ad_field_type~is_built_in_type.
    rv_result = xsdbool( mv_data_element IS INITIAL AND ms_built_in-type IS NOT INITIAL ).
  ENDMETHOD.

  METHOD if_xco_ad_field_type~get_data_element.
    IF mv_data_element IS NOT INITIAL.
      ro_data_element = xco_cp_abap_dictionary=>data_element( CONV #( mv_data_element ) ).
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_ad_field_type~get_built_in_type.
    IF if_xco_ad_field_type~is_built_in_type( ) = abap_true.
      ro_built_in_type = NEW #(
        iv_type     = ms_built_in-type
        iv_length   = ms_built_in-length
        iv_decimals = ms_built_in-decimals ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
