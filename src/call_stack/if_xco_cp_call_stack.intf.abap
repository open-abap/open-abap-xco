INTERFACE if_xco_cp_call_stack PUBLIC.
  METHODS as_text
    IMPORTING
      io_format      TYPE REF TO if_xco_cs_format
    RETURNING
      VALUE(ro_text) TYPE REF TO if_xco_text.
ENDINTERFACE.
