CLASS cl_xco_ad_structure DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_ad_structure.

    METHODS constructor
      IMPORTING
        iv_name TYPE csequence.
ENDCLASS.

CLASS cl_xco_ad_structure IMPLEMENTATION.
  METHOD constructor.
    if_xco_ar_object~name = to_upper( condense( iv_name ) ).
  ENDMETHOD.

  METHOD if_xco_ar_object~exists.
* structures and database tables are both TABL
    rv_exists = xsdbool( cl_xco_runtime_ddic=>object_type( if_xco_ar_object~name ) = 'TABL' ).
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

  METHOD if_xco_ad_structure~content.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
