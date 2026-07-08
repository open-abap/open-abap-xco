INTERFACE if_xco_ttyp_content PUBLIC.
  METHODS get_row_type
    RETURNING
      VALUE(ro_row_type) TYPE REF TO if_xco_ttyp_row_type.
ENDINTERFACE.