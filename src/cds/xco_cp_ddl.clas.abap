CLASS xco_cp_ddl DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA expression TYPE REF TO if_xco_ddl_expression_factory READ-ONLY.
    CLASS-DATA data_source TYPE REF TO if_xco_ddl_data_source_factory READ-ONLY.

    CLASS-METHODS field
      IMPORTING iv_name         TYPE csequence
      RETURNING VALUE(ro_field) TYPE REF TO if_xco_ddl_expr_condition.
ENDCLASS.

CLASS xco_cp_ddl IMPLEMENTATION.
  METHOD field.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
