CLASS xco_cp_ddl DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS field
      IMPORTING iv_name         TYPE csequence
      RETURNING VALUE(ro_field) TYPE REF TO if_xco_gen_ddls_ddl_expression.
ENDCLASS.

CLASS xco_cp_ddl IMPLEMENTATION.
  METHOD field.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
