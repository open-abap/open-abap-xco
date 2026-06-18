CLASS cl_xco_cp_table_origin DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS local RETURNING VALUE(rv_origin) TYPE string.
ENDCLASS.

CLASS cl_xco_cp_table_origin IMPLEMENTATION.
  METHOD local.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
