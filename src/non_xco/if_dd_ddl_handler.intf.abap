INTERFACE if_dd_ddl_handler PUBLIC.

  METHODS read
    IMPORTING
      name         TYPE char40
    EXPORTING
      ddddlsrcv_wa TYPE ddddlsrcv.

ENDINTERFACE.