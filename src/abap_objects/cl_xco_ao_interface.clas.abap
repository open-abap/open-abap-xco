CLASS cl_xco_ao_interface DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_ao_interface.

    METHODS constructor
      IMPORTING
        iv_name TYPE csequence.
ENDCLASS.

CLASS cl_xco_ao_interface IMPLEMENTATION.
  METHOD constructor.
    if_xco_ar_object~name = to_upper( condense( iv_name ) ).
  ENDMETHOD.

  METHOD if_xco_ao_interface~exists.
    rv_exists = if_xco_ar_object~exists( ).
  ENDMETHOD.

  METHOD if_xco_ar_object~exists.
    rv_exists = cl_xco_runtime_ddic=>tadir_exists(
      iv_object = 'INTF'
      iv_name   = if_xco_ar_object~name ).
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
ENDCLASS.
