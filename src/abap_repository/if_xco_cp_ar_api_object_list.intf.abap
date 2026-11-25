INTERFACE if_xco_cp_ar_api_object_list PUBLIC.
  DATA all TYPE REF TO if_xco_cp_ar_api_object_query READ-ONLY.

  METHODS where
    IMPORTING
      it_filters      TYPE sxco_t_ar_filters
    RETURNING
      VALUE(ro_query) TYPE REF TO if_xco_cp_ar_api_object_query.
ENDINTERFACE.
