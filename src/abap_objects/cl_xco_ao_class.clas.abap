CLASS cl_xco_ao_class DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_ao_class.

    METHODS constructor
      IMPORTING
        iv_name TYPE csequence.
ENDCLASS.

CLASS cl_xco_ao_class IMPLEMENTATION.
  METHOD constructor.
    if_xco_ar_object~name = to_upper( condense( iv_name ) ).
  ENDMETHOD.

  METHOD if_xco_ar_object~exists.
    rv_exists = cl_xco_runtime_ddic=>tadir_exists(
      iv_object = 'CLAS'
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

  METHOD if_xco_ao_class~set_api_state.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_xco_ao_class~content.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
