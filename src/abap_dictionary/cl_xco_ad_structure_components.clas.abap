CLASS cl_xco_ad_structure_components DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_ad_structure_components.

    METHODS constructor
      IMPORTING
        iv_structure TYPE csequence.

  PRIVATE SECTION.
    DATA mv_structure TYPE string.
ENDCLASS.

CLASS cl_xco_ad_structure_components IMPLEMENTATION.
  METHOD constructor.
    mv_structure = iv_structure.
    if_xco_ad_structure_components~all = me.
  ENDMETHOD.

  METHOD if_xco_ad_structure_components~get.
* in declaration order, with the components of included structures in place of the include
    DATA(ls_structure) = cl_xco_runtime_ddic=>structure( mv_structure ).
    LOOP AT ls_structure-components INTO DATA(ls_component).
      APPEND NEW cl_xco_ad_structure_component( ls_component ) TO rt_components.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
