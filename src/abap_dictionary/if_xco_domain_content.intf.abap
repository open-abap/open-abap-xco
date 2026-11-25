INTERFACE if_xco_domain_content PUBLIC.
  TYPES: BEGIN OF ts_domain,
           format TYPE REF TO if_xco_domain_format,
         END OF ts_domain.

  METHODS get
    RETURNING VALUE(rs_domain) TYPE ts_domain.

  TYPES: BEGIN OF ts_output_characteristics,
      output_length      TYPE n LENGTH 6,
      conversion_routine TYPE c LENGTH 5,
      case_sensitive     TYPE abap_bool,
      sign               TYPE abap_bool,
      am_pm_format       TYPE abap_bool,
      output_style       TYPE REF TO cl_xco_domain_output_style,
    END OF ts_output_characteristics.

  METHODS get_output_characteristics
    RETURNING
      VALUE(rs_output_characteristics) TYPE ts_output_characteristics.
ENDINTERFACE.
