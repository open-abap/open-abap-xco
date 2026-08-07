CLASS ltcl_xco_cp_abap_dictionary DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS object_name FOR TESTING.
ENDCLASS.

CLASS ltcl_xco_cp_abap_dictionary IMPLEMENTATION.
  METHOD object_name.
    DATA lv_name TYPE sxco_ad_object_name.

    lv_name = 'ZDEMO_DTEL'.

    cl_abap_unit_assert=>assert_equals(
      act = lv_name
      exp = 'ZDEMO_DTEL' ).
    cl_abap_unit_assert=>assert_equals(
      act = strlen( CONV sxco_ad_object_name( repeat( val = 'A' occ = 40 ) ) )
      exp = 30 ).
  ENDMETHOD.
ENDCLASS.
