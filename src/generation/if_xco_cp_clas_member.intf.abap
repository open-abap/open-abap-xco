INTERFACE if_xco_cp_clas_member PUBLIC.
  METHODS for_table_type
    IMPORTING io_row_type      TYPE REF TO if_xco_ad_type OPTIONAL
              io_primary_key   TYPE REF TO object OPTIONAL
    RETURNING VALUE(ro_member) TYPE REF TO if_xco_cp_clas_member.
  METHODS add_returning_parameter
    IMPORTING iv_name          TYPE csequence
    RETURNING VALUE(ro_member) TYPE REF TO if_xco_cp_clas_member.
  METHODS set_type
    IMPORTING io_type          TYPE REF TO if_xco_ad_type
    RETURNING VALUE(ro_member) TYPE REF TO if_xco_cp_clas_member.
  METHODS set_read_only
    RETURNING VALUE(ro_member) TYPE REF TO if_xco_cp_clas_member.
  METHODS set_source
    IMPORTING it_source        TYPE STANDARD TABLE
    RETURNING VALUE(ro_member) TYPE REF TO if_xco_cp_clas_member.
ENDINTERFACE.
