CLASS cl_xco_cp_adt_simple_classrun DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.

    METHODS main
      IMPORTING
        out TYPE REF TO if_xco_adt_classrun_out.
ENDCLASS.

CLASS cl_xco_cp_adt_simple_classrun IMPLEMENTATION.
  METHOD main.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.