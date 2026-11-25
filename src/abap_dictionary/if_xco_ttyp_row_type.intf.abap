INTERFACE if_xco_ttyp_row_type PUBLIC.
  METHODS is_structure
    RETURNING
      VALUE(rv_is_structure) TYPE abap_bool.
  METHODS get_structure
    RETURNING
      VALUE(ro_structure) TYPE REF TO if_xco_ad_structure.

  METHODS is_data_element DEFAULT IGNORE
    RETURNING
      VALUE(rv_is_data_element) TYPE abap_bool.
  METHODS get_data_element DEFAULT IGNORE
    RETURNING
      VALUE(ro_data_element) TYPE REF TO if_xco_ad_data_element.

  METHODS is_table_type DEFAULT IGNORE
    RETURNING
      VALUE(rv_is_table_type) TYPE abap_bool.
  METHODS get_table_type DEFAULT IGNORE
    RETURNING
      VALUE(ro_table_type) TYPE REF TO if_xco_ad_table_type.

  METHODS is_interface DEFAULT IGNORE
    RETURNING
      VALUE(rv_is_interface) TYPE abap_bool.
  METHODS get_interface DEFAULT IGNORE
    RETURNING
      VALUE(ro_interface) TYPE REF TO if_xco_ao_interface.

  METHODS is_class DEFAULT IGNORE
    RETURNING
      VALUE(rv_is_class) TYPE abap_bool.
  METHODS get_class DEFAULT IGNORE
    RETURNING
      VALUE(ro_class) TYPE REF TO if_xco_ao_class.
ENDINTERFACE.