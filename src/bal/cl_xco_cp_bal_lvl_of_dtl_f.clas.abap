CLASS cl_xco_cp_bal_lvl_of_dtl_f DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA one   TYPE REF TO cl_xco_bal_level_of_detail READ-ONLY.
    DATA two   TYPE REF TO cl_xco_bal_level_of_detail READ-ONLY.
    DATA three TYPE REF TO cl_xco_bal_level_of_detail READ-ONLY.
    DATA four  TYPE REF TO cl_xco_bal_level_of_detail READ-ONLY.
    DATA five  TYPE REF TO cl_xco_bal_level_of_detail READ-ONLY.
    DATA six   TYPE REF TO cl_xco_bal_level_of_detail READ-ONLY.
    DATA seven TYPE REF TO cl_xco_bal_level_of_detail READ-ONLY.
    DATA eight TYPE REF TO cl_xco_bal_level_of_detail READ-ONLY.
    DATA nine  TYPE REF TO cl_xco_bal_level_of_detail READ-ONLY.

    METHODS for
      IMPORTING
        iv_value                  TYPE cl_xco_bal_level_of_detail=>tv_value
      RETURNING
        VALUE(ro_level_of_detail) TYPE REF TO cl_xco_bal_level_of_detail.
ENDCLASS.

CLASS cl_xco_cp_bal_lvl_of_dtl_f IMPLEMENTATION.

  METHOD for.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.