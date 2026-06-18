INTERFACE if_xco_gen_o_findings PUBLIC.
  METHODS get
    RETURNING
      VALUE(rt_findings) TYPE sxco_t_gen_o_findings.
  METHODS contain_warnings
    RETURNING
      VALUE(rv_contains_warnings) TYPE abap_bool.
  METHODS contain_errors
    RETURNING
      VALUE(rv_contains_errors) TYPE abap_bool.
ENDINTERFACE.
