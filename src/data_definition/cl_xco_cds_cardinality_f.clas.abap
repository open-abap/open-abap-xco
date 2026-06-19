CLASS cl_xco_cds_cardinality_f DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA one TYPE REF TO object READ-ONLY.
    DATA zero_to_one TYPE REF TO cl_xco_cds_cardinality_c READ-ONLY.
    DATA one_to_n TYPE REF TO cl_xco_cds_cardinality_c READ-ONLY.
    DATA zero_to_n TYPE REF TO cl_xco_cds_cardinality_c READ-ONLY.

    METHODS range
      IMPORTING
        iv_min                TYPE i OPTIONAL
        iv_max                TYPE i OPTIONAL
      RETURNING
        VALUE(ro_cardinality) TYPE REF TO object.
ENDCLASS.

CLASS cl_xco_cds_cardinality_f IMPLEMENTATION.

  METHOD range.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
