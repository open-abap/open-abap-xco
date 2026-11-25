CLASS ltcl_xco_uuid DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS supplied_value FOR TESTING.
    METHODS generated_value FOR TESTING.
ENDCLASS.

CLASS ltcl_xco_uuid IMPLEMENTATION.
  METHOD supplied_value.
    DATA lv_value TYPE sysuuid_x16.

    lv_value = '00112233445566778899AABBCCDDEEFF'.
    DATA(lo_uuid) = xco_cp=>uuid( lv_value ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_uuid->value
      exp = lv_value ).
  ENDMETHOD.

  METHOD generated_value.
    DATA(lo_uuid) = xco_cp=>uuid( ).

    cl_abap_unit_assert=>assert_not_initial( lo_uuid->value ).
  ENDMETHOD.
ENDCLASS.
