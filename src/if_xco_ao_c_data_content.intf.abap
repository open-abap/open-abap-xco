INTERFACE if_xco_ao_c_data_content PUBLIC.

  TYPES:
    BEGIN OF ts_content,
      short_description   TYPE sxco_ar_short_description,
      typing_method       TYPE REF TO cl_xco_ao_typing_method,
      typing_definition   TYPE REF TO if_xco_ao_typing_definition,
      read_only_indicator TYPE abap_bool,
    END OF ts_content.

  METHODS get
    RETURNING
      VALUE(rs_content) TYPE ts_content.

  METHODS get_short_description
    RETURNING
      VALUE(rv_short_description) TYPE sxco_ar_short_description.
ENDINTERFACE.