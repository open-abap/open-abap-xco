INTERFACE if_xco_cp_std_sy PUBLIC.
  INTERFACES if_xco_news.

  METHODS message
    RETURNING
      VALUE(ro_message) TYPE REF TO if_xco_message.
ENDINTERFACE.
