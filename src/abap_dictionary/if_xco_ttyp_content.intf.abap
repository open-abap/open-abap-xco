INTERFACE if_xco_ttyp_content PUBLIC.
  METHODS get_row_type
    RETURNING
      VALUE(ro_row_type) TYPE REF TO if_xco_ttyp_row_type.

  METHODS
    get_short_description
      RETURNING
        VALUE(rv_short_description) TYPE sxco_ar_short_description.
ENDINTERFACE.