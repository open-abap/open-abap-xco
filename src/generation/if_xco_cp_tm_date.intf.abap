INTERFACE if_xco_cp_tm_date PUBLIC.

  METHODS as
    IMPORTING
      io_format        TYPE REF TO if_xco_cp_tm_date_format
    RETURNING
      VALUE(ro_string) TYPE REF TO if_xco_string.

ENDINTERFACE.