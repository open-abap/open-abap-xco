CLASS ltcl_base64 DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS c_hello_world_hex TYPE string VALUE `48656C6C6F20776F726C64`.
    CONSTANTS c_hello_world_base64 TYPE string VALUE `SGVsbG8gd29ybGQ=`.

    METHODS encode FOR TESTING.
    METHODS decode FOR TESTING.
    METHODS round_trip FOR TESTING.
    METHODS padding FOR TESTING.
    METHODS empty FOR TESTING.
    METHODS character_outside_alphabet FOR TESTING.
    METHODS incomplete_group FOR TESTING.
    METHODS padding_inside FOR TESTING.
    METHODS too_much_padding FOR TESTING.

    METHODS encode_base64
      IMPORTING
        iv_bytes         TYPE xstring
      RETURNING
        VALUE(rv_base64) TYPE string.

    METHODS decode_base64
      IMPORTING
        iv_base64       TYPE string
      RETURNING
        VALUE(rv_bytes) TYPE xstring.

    METHODS assert_rejected
      IMPORTING
        iv_base64 TYPE string.
ENDCLASS.

CLASS ltcl_base64 IMPLEMENTATION.
  METHOD encode_base64.
    DATA(lo_string) = xco_cp=>xstring( iv_bytes )->as_string( xco_cp_binary=>text_encoding->base64 ).
    rv_base64 = lo_string->value.
  ENDMETHOD.

  METHOD decode_base64.
    DATA(lo_xstring) = xco_cp=>string( iv_base64 )->as_xstring( xco_cp_binary=>text_encoding->base64 ).
    rv_bytes = lo_xstring->value.
  ENDMETHOD.

  METHOD assert_rejected.
    TRY.
        xco_cp=>string( iv_base64 )->as_xstring( xco_cp_binary=>text_encoding->base64 ).
        cl_abap_unit_assert=>fail( |{ iv_base64 } was accepted| ).
      CATCH cx_xco_runtime_exception.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD encode.
    cl_abap_unit_assert=>assert_equals(
      act = encode_base64( CONV #( c_hello_world_hex ) )
      exp = c_hello_world_base64 ).
  ENDMETHOD.

  METHOD decode.
    cl_abap_unit_assert=>assert_equals(
      act = decode_base64( c_hello_world_base64 )
      exp = CONV xstring( c_hello_world_hex ) ).
  ENDMETHOD.

  METHOD round_trip.
    DATA(lv_bytes) = CONV xstring( '00FF7F80CAFE' ).

    DATA(lv_base64) = encode_base64( lv_bytes ).

    cl_abap_unit_assert=>assert_equals(
      act = decode_base64( lv_base64 )
      exp = lv_bytes ).
  ENDMETHOD.

  METHOD padding.
    cl_abap_unit_assert=>assert_equals(
      act = decode_base64( `eg==` )
      exp = CONV xstring( '7A' ) ).
    cl_abap_unit_assert=>assert_equals(
      act = decode_base64( `SGVsbG8=` )
      exp = CONV xstring( '48656C6C6F' ) ).
  ENDMETHOD.

  METHOD empty.
    DATA lv_empty TYPE xstring.

    cl_abap_unit_assert=>assert_initial( encode_base64( lv_empty ) ).
    cl_abap_unit_assert=>assert_initial( decode_base64( `` ) ).
  ENDMETHOD.

  METHOD character_outside_alphabet.
    assert_rejected( `SGVs*G8=` ).
  ENDMETHOD.

  METHOD incomplete_group.
    assert_rejected( `SGVsbG8` ).
  ENDMETHOD.

  METHOD padding_inside.
    assert_rejected( `SG=sbG8=` ).
  ENDMETHOD.

  METHOD too_much_padding.
    assert_rejected( `A===` ).
  ENDMETHOD.
ENDCLASS.
