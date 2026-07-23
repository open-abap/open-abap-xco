INTERFACE if_xco_uuid_format PUBLIC.
  METHODS to_uuid
    IMPORTING
      iv_string      TYPE csequence
    RETURNING
      VALUE(ro_uuid) TYPE REF TO if_xco_uuid.

  METHODS from_uuid
    IMPORTING
      io_uuid          TYPE REF TO if_xco_uuid
    RETURNING
      VALUE(rv_string) TYPE string.
ENDINTERFACE.
