CLASS cl_xco_abap_sql_constraint_f DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS contains_pattern
      IMPORTING iv_pattern           TYPE csequence
      RETURNING VALUE(ro_constraint) TYPE REF TO object.

    METHODS equal
      IMPORTING iv_value             TYPE csequence
      RETURNING VALUE(ro_constraint) TYPE REF TO object.
ENDCLASS.

CLASS cl_xco_abap_sql_constraint_f IMPLEMENTATION.
  METHOD contains_pattern.
    CLEAR ro_constraint.
  ENDMETHOD.

  METHOD equal.
    CLEAR ro_constraint.
  ENDMETHOD.
ENDCLASS.
