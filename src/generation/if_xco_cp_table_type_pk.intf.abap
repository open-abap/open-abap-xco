INTERFACE if_xco_cp_table_type_pk PUBLIC.
  DATA not_specified TYPE REF TO object READ-ONLY.

  METHODS not_specified
    IMPORTING io_key_category       TYPE REF TO object OPTIONAL
    RETURNING VALUE(ro_primary_key) TYPE REF TO object.
ENDINTERFACE.
