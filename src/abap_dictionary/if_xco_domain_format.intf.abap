INTERFACE if_xco_domain_format PUBLIC.
  METHODS get_built_in_type
    RETURNING VALUE(ro_built_in_type) TYPE REF TO cl_xco_ad_built_in_type.
ENDINTERFACE.
