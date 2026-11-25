CLASS cl_xco_ad_table_type DEFINITION PUBLIC FINAL CREATE PUBLIC.
* read access to a table type, the content and the row type are the same object
  PUBLIC SECTION.
    INTERFACES if_xco_ad_table_type.
    INTERFACES if_xco_ttyp_content.
    INTERFACES if_xco_ttyp_row_type.

    METHODS constructor
      IMPORTING
        iv_name TYPE csequence.

  PRIVATE SECTION.
    DATA mv_read TYPE abap_bool.
    DATA ms_table_type TYPE cl_xco_runtime_ddic=>ty_table_type.

    METHODS read
      RETURNING
        VALUE(rs_table_type) TYPE cl_xco_runtime_ddic=>ty_table_type.

    METHODS row_name
      IMPORTING
        iv_kind        TYPE string
      RETURNING
        VALUE(rv_name) TYPE string.
ENDCLASS.

CLASS cl_xco_ad_table_type IMPLEMENTATION.
  METHOD constructor.
    if_xco_ar_object~name = to_upper( condense( iv_name ) ).
  ENDMETHOD.

  METHOD read.
    IF mv_read = abap_false.
      ms_table_type = cl_xco_runtime_ddic=>table_type( if_xco_ar_object~name ).
      mv_read = abap_true.
    ENDIF.
    rs_table_type = ms_table_type.
  ENDMETHOD.

  METHOD row_name.
* the referenced name, initial if the row type is of another kind
    DATA(ls_table_type) = read( ).
    IF ls_table_type-row_kind = iv_kind.
      rv_name = ls_table_type-row_name.
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_ad_table_type~exists.
    rv_exists = read( )-found.
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

  METHOD if_xco_ad_table_type~content.
    ro_content = me.
  ENDMETHOD.

  METHOD if_xco_ttyp_content~get_row_type.
    ro_row_type = me.
  ENDMETHOD.

  METHOD if_xco_ttyp_content~get_short_description.
    rv_short_description = read( )-description.
  ENDMETHOD.

  METHOD if_xco_ttyp_row_type~is_data_element.
    rv_is_data_element = xsdbool( read( )-row_kind = 'DATA_ELEMENT' ).
  ENDMETHOD.

  METHOD if_xco_ttyp_row_type~get_data_element.
    DATA(lv_name) = row_name( 'DATA_ELEMENT' ).
    IF lv_name IS NOT INITIAL.
      ro_data_element = xco_cp_abap_dictionary=>data_element( CONV #( lv_name ) ).
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_ttyp_row_type~is_structure.
    rv_is_structure = xsdbool( read( )-row_kind = 'STRUCTURE' ).
  ENDMETHOD.

  METHOD if_xco_ttyp_row_type~get_structure.
    DATA(lv_name) = row_name( 'STRUCTURE' ).
    IF lv_name IS NOT INITIAL.
      ro_structure = xco_cp_abap_dictionary=>structure( CONV #( lv_name ) ).
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_ttyp_row_type~is_table_type.
    rv_is_table_type = xsdbool( read( )-row_kind = 'TABLE_TYPE' ).
  ENDMETHOD.

  METHOD if_xco_ttyp_row_type~get_table_type.
    DATA(lv_name) = row_name( 'TABLE_TYPE' ).
    IF lv_name IS NOT INITIAL.
      ro_table_type = xco_cp_abap_dictionary=>table_type( CONV #( lv_name ) ).
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_ttyp_row_type~is_interface.
    rv_is_interface = xsdbool( read( )-row_kind = 'INTERFACE' ).
  ENDMETHOD.

  METHOD if_xco_ttyp_row_type~get_interface.
    DATA(lv_name) = row_name( 'INTERFACE' ).
    IF lv_name IS NOT INITIAL.
      ro_interface = xco_cp_abap=>interface( CONV #( lv_name ) ).
    ENDIF.
  ENDMETHOD.

  METHOD if_xco_ttyp_row_type~is_class.
    rv_is_class = xsdbool( read( )-row_kind = 'CLASS' ).
  ENDMETHOD.

  METHOD if_xco_ttyp_row_type~get_class.
    DATA(lv_name) = row_name( 'CLASS' ).
    IF lv_name IS NOT INITIAL.
      ro_class = xco_cp_abap=>class( lv_name ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
