CLASS xco_cp_abap_dictionary DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA built_in_type TYPE REF TO cl_xco_ad_built_in_type_f READ-ONLY.

    CLASS-METHODS data_element
      IMPORTING iv_name        TYPE csequence
      RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_built_in_type_rfrnc.
    CLASS-METHODS table_type
      IMPORTING iv_name        TYPE csequence
      RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_built_in_type_rfrnc.
ENDCLASS.

CLASS xco_cp_abap_dictionary IMPLEMENTATION.
  METHOD data_element.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD table_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
