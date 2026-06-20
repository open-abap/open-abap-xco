INTERFACE if_sadl_exit_calc_element_read PUBLIC.
  METHODS calculate
    IMPORTING it_original_data   TYPE ANY TABLE OPTIONAL
    CHANGING  ct_calculated_data TYPE ANY TABLE.
  METHODS get_calculation_info
    IMPORTING iv_entity                  TYPE string OPTIONAL
              it_requested_calc_elements TYPE string_table OPTIONAL
    EXPORTING et_requested_orig_elements TYPE string_table.
ENDINTERFACE.
