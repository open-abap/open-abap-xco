INTERFACE if_xco_cp_tm_time PUBLIC.

  METHODS
    as
      IMPORTING
        io_format        TYPE REF TO if_xco_cp_tm_time_format
      RETURNING
        VALUE(ro_string) TYPE REF TO if_xco_string.

ENDINTERFACE.