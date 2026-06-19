CLASS cl_dd_abap_language_version DEFINITION PUBLIC.
  PUBLIC SECTION.

    CLASS-METHODS get_abap_language_version
      IMPORTING
        iv_object_type                  TYPE any
        iv_object_name                  TYPE sobj_name
      RETURNING
        VALUE(rv_abap_language_version) TYPE abap_language_version.

ENDCLASS.

CLASS cl_dd_abap_language_version IMPLEMENTATION.
  METHOD get_abap_language_version.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
