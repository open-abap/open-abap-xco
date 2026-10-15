CLASS ltcl_uuid_format DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS c_c32 TYPE string VALUE `429A229A88021EDFB7E2E25DF99B0E73`.
    CONSTANTS c_c36 TYPE string VALUE `429A229A-8802-1EDF-B7E2-E25DF99B0E73`.

    METHODS as_c32 FOR TESTING.
    METHODS as_c36 FOR TESTING.
    METHODS as_c22 FOR TESTING.
    METHODS c32_to_uuid FOR TESTING.
    METHODS c36_to_uuid FOR TESTING.
    METHODS lower_case_to_uuid FOR TESTING.
    METHODS c22_round_trip FOR TESTING.
    METHODS c32_from_c36 FOR TESTING.
    METHODS initial_uuid FOR TESTING.
    METHODS wrong_length FOR TESTING.
    METHODS not_hexadecimal FOR TESTING.
    METHODS misplaced_hyphen FOR TESTING.
    METHODS invalid_c22 FOR TESTING.

    METHODS sample
      RETURNING
        VALUE(ro_uuid) TYPE REF TO if_xco_uuid.

    METHODS value_of
      IMPORTING
        io_string       TYPE REF TO if_xco_string
      RETURNING
        VALUE(rv_value) TYPE string.

    METHODS x16_of
      IMPORTING
        io_uuid         TYPE REF TO if_xco_uuid
      RETURNING
        VALUE(rv_value) TYPE sysuuid_x16.

    METHODS assert_rejected
      IMPORTING
        io_format TYPE REF TO if_xco_uuid_format
        iv_string TYPE string.
ENDCLASS.

CLASS ltcl_uuid_format IMPLEMENTATION.
  METHOD value_of.
    rv_value = io_string->value.
  ENDMETHOD.

  METHOD x16_of.
    rv_value = io_uuid->value.
  ENDMETHOD.

  METHOD sample.
    ro_uuid = xco_cp=>uuid( CONV sysuuid_x16( c_c32 ) ).
  ENDMETHOD.

  METHOD assert_rejected.
    TRY.
        io_format->to_uuid( iv_string ).
        cl_abap_unit_assert=>fail( |{ iv_string } was accepted| ).
      CATCH cx_xco_runtime_exception.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD as_c32.
    cl_abap_unit_assert=>assert_equals(
      act = value_of( sample( )->as( xco_cp_uuid=>format->c32 ) )
      exp = c_c32 ).
  ENDMETHOD.

  METHOD as_c36.
    cl_abap_unit_assert=>assert_equals(
      act = value_of( sample( )->as( xco_cp_uuid=>format->c36 ) )
      exp = c_c36 ).
  ENDMETHOD.

  METHOD as_c22.
    " the sample pair of the SAP documentation of the UUID formats
    cl_abap_unit_assert=>assert_equals(
      act = value_of( xco_cp=>uuid( CONV sysuuid_x16( '12837204B4991EDC9FC0675639081656' ) )->as( xco_cp_uuid=>format->c22 ) )
      exp = `4eDo1BIP7joVm6TMEGWMLW` ).
    cl_abap_unit_assert=>assert_equals(
      act = x16_of( xco_cp_uuid=>format->c22->to_uuid( `4eDo1BIP7joVm6TMEGWMLW` ) )
      exp = CONV sysuuid_x16( '12837204B4991EDC9FC0675639081656' ) ).
  ENDMETHOD.

  METHOD c32_to_uuid.
    cl_abap_unit_assert=>assert_equals(
      act = x16_of( xco_cp_uuid=>format->c32->to_uuid( c_c32 ) )
      exp = x16_of( sample( ) ) ).
  ENDMETHOD.

  METHOD c36_to_uuid.
    cl_abap_unit_assert=>assert_equals(
      act = x16_of( xco_cp_uuid=>format->c36->to_uuid( c_c36 ) )
      exp = x16_of( sample( ) ) ).
  ENDMETHOD.

  METHOD lower_case_to_uuid.
    cl_abap_unit_assert=>assert_equals(
      act = x16_of( xco_cp_uuid=>format->c36->to_uuid( to_lower( c_c36 ) ) )
      exp = x16_of( sample( ) ) ).
  ENDMETHOD.

  METHOD c22_round_trip.
    DATA(lv_c22) = xco_cp_uuid=>format->c22->from_uuid( sample( ) ).

    cl_abap_unit_assert=>assert_equals(
      act = x16_of( xco_cp_uuid=>format->c22->to_uuid( lv_c22 ) )
      exp = x16_of( sample( ) ) ).
  ENDMETHOD.

  METHOD c32_from_c36.
    cl_abap_unit_assert=>assert_equals(
      act = xco_cp_uuid=>format->c32->from_uuid( xco_cp_uuid=>format->c36->to_uuid( c_c36 ) )
      exp = c_c32 ).
  ENDMETHOD.

  METHOD initial_uuid.
    DATA lv_initial TYPE sysuuid_x16.

    cl_abap_unit_assert=>assert_equals(
      act = value_of( xco_cp=>uuid( lv_initial )->as( xco_cp_uuid=>format->c36 ) )
      exp = `00000000-0000-0000-0000-000000000000` ).
  ENDMETHOD.

  METHOD wrong_length.
    assert_rejected( io_format = xco_cp_uuid=>format->c32
                     iv_string = `429A229A88021EDF` ).
    assert_rejected( io_format = xco_cp_uuid=>format->c32
                     iv_string = c_c32 && `00` ).
    assert_rejected( io_format = xco_cp_uuid=>format->c36
                     iv_string = c_c32 ).
    assert_rejected( io_format = xco_cp_uuid=>format->c22
                     iv_string = `` ).
  ENDMETHOD.

  METHOD not_hexadecimal.
    assert_rejected( io_format = xco_cp_uuid=>format->c32
                     iv_string = `ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ` ).
  ENDMETHOD.

  METHOD misplaced_hyphen.
    assert_rejected( io_format = xco_cp_uuid=>format->c36
                     iv_string = `429A229A8-802-1EDF-B7E2-E25DF99B0E73` ).
  ENDMETHOD.

  METHOD invalid_c22.
    assert_rejected( io_format = xco_cp_uuid=>format->c22
                     iv_string = `!!!!!!!!!!!!!!!!!!!!!!` ).
  ENDMETHOD.
ENDCLASS.
