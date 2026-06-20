INTERFACE if_xco_domain_content PUBLIC.
  TYPES: BEGIN OF ts_domain,
           format TYPE REF TO if_xco_domain_format,
         END OF ts_domain.

  METHODS get
    RETURNING VALUE(rs_domain) TYPE ts_domain.
ENDINTERFACE.
