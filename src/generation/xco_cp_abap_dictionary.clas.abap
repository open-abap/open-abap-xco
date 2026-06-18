CLASS xco_cp_abap_dictionary DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA built_in_type TYPE REF TO if_xco_cp_built_in_type READ-ONLY.

    CLASS-METHODS data_element
      IMPORTING iv_name        TYPE csequence
      RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
    CLASS-METHODS table_type
      IMPORTING iv_name        TYPE csequence
      RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
ENDCLASS.

CLASS xco_cp_abap_dictionary IMPLEMENTATION.
  METHOD data_element.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD table_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
