INTERFACE if_xco_clas_content PUBLIC.
  METHODS get_short_description
    RETURNING
      VALUE(rv_short_description) TYPE sxco_ar_short_description.
ENDINTERFACE.