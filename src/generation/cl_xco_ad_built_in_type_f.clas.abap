CLASS cl_xco_ad_built_in_type_f DEFINITION PUBLIC.
  PUBLIC SECTION.
    DATA accp TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA clnt TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA cuky TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA dats TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA df16_raw TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA df34_raw TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA fltp TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA int1 TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA int2 TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA int4 TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA int8 TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA lang TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.
    DATA tims TYPE REF TO cl_xco_ad_built_in_type READ-ONLY.

    METHODS char
      IMPORTING iv_length      TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS curr
      IMPORTING iv_length      TYPE i
                iv_decimals    TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS dec
      IMPORTING iv_length      TYPE i
                iv_decimals    TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS df16_dec
      IMPORTING iv_length      TYPE i
                iv_decimals    TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS df34_dec
      IMPORTING iv_length      TYPE i
                iv_decimals    TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS lchr
      IMPORTING iv_length      TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS lraw
      IMPORTING iv_length      TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS numc
      IMPORTING iv_length      TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS quan
      IMPORTING iv_length      TYPE i
                iv_decimals    TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS raw
      IMPORTING iv_length      TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS rawstring
      IMPORTING iv_length      TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS sstring
      IMPORTING iv_length      TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS string
      IMPORTING iv_length      TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS unit
      IMPORTING iv_length      TYPE i
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
    METHODS for
      IMPORTING iv_type        TYPE csequence
                iv_length      TYPE i OPTIONAL
                iv_decimals    TYPE i OPTIONAL
      RETURNING VALUE(ro_type) TYPE REF TO cl_xco_ad_built_in_type.
ENDCLASS.

CLASS cl_xco_ad_built_in_type_f IMPLEMENTATION.
  METHOD char.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD curr.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD dec.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD df16_dec.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD df34_dec.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD lchr.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD lraw.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD numc.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD quan.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD raw.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD rawstring.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD sstring.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD string.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD unit.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD for.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
