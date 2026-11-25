CLASS cl_xco_ad_structure DEFINITION PUBLIC FINAL CREATE PUBLIC.
* read access to a structure, the content is the same object
  PUBLIC SECTION.
    INTERFACES if_xco_ad_structure.
    INTERFACES if_xco_str_content.

    METHODS constructor
      IMPORTING
        iv_name TYPE csequence.
ENDCLASS.

CLASS cl_xco_ad_structure IMPLEMENTATION.
  METHOD constructor.
    if_xco_ar_object~name = to_upper( condense( iv_name ) ).
    if_xco_ad_structure~components = NEW cl_xco_ad_structure_components( if_xco_ar_object~name ).
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
    ro_content = me.
  ENDMETHOD.

  METHOD if_xco_str_content~get_short_description.
    rv_short_description = cl_xco_runtime_ddic=>structure( if_xco_ar_object~name )-description.
  ENDMETHOD.
ENDCLASS.
