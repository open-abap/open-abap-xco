CLASS xco_cp_abap DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA repository TYPE REF TO object READ-ONLY.

    CLASS-METHODS class
      IMPORTING
        iv_name         TYPE csequence
      RETURNING
        VALUE(ro_class) TYPE REF TO if_xco_ao_class.
ENDCLASS.

CLASS xco_cp_abap IMPLEMENTATION.
  METHOD class.
    CLEAR ro_class.
  ENDMETHOD.
ENDCLASS.
