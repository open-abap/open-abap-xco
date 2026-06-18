INTERFACE if_xco_cp_built_in_type PUBLIC.
  DATA accp TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA clnt TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA cuky TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA dats TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA df16_raw TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA df34_raw TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA fltp TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA int1 TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA int2 TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA int4 TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA int8 TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA lang TYPE REF TO if_xco_ad_type READ-ONLY.
  DATA tims TYPE REF TO if_xco_ad_type READ-ONLY.

  METHODS char
    IMPORTING iv_length      TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS curr
    IMPORTING iv_length      TYPE i
              iv_decimals    TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS dec
    IMPORTING iv_length      TYPE i
              iv_decimals    TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS df16_dec
    IMPORTING iv_length      TYPE i
              iv_decimals    TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS df34_dec
    IMPORTING iv_length      TYPE i
              iv_decimals    TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS lchr
    IMPORTING iv_length      TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS lraw
    IMPORTING iv_length      TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS numc
    IMPORTING iv_length      TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS quan
    IMPORTING iv_length      TYPE i
              iv_decimals    TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS raw
    IMPORTING iv_length      TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS rawstring
    IMPORTING iv_length      TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS sstring
    IMPORTING iv_length      TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS string
    IMPORTING iv_length      TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS unit
    IMPORTING iv_length      TYPE i
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
  METHODS for
    IMPORTING iv_type        TYPE csequence
              iv_length      TYPE i OPTIONAL
              iv_decimals    TYPE i OPTIONAL
    RETURNING VALUE(ro_type) TYPE REF TO if_xco_ad_type.
ENDINTERFACE.
