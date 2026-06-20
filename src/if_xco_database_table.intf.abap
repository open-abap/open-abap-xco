INTERFACE if_xco_database_table PUBLIC.
  INTERFACES if_xco_ar_object.
  INTERFACES if_xco_cts_changeable.

  ALIASES exists FOR if_xco_ar_object~exists.
  ALIASES name FOR if_xco_ar_object~name.
  ALIASES get_state FOR if_xco_ar_object~get_state.
  ALIASES get_object FOR if_xco_cts_changeable~get_object.

  DATA fields TYPE REF TO if_xco_database_table_fields READ-ONLY.

  METHODS content
    RETURNING
      VALUE(ro_content) TYPE REF TO if_xco_database_table_content.
ENDINTERFACE.
