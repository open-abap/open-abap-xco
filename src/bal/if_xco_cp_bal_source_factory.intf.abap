INTERFACE if_xco_cp_bal_source_factory PUBLIC.
  METHODS database
    RETURNING
      VALUE(ro_source) TYPE REF TO if_xco_cp_bal_source.
ENDINTERFACE.
