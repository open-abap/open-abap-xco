INTERFACE if_xco_cp_gen_tabl_curr_qty PUBLIC.
  METHODS set_reference_table
    IMPORTING
      iv_table                    TYPE csequence
    RETURNING
      VALUE(ro_currency_quantity) TYPE REF TO if_xco_cp_gen_tabl_curr_qty.
  METHODS set_reference_field
    IMPORTING
      iv_field                    TYPE csequence
    RETURNING
      VALUE(ro_currency_quantity) TYPE REF TO if_xco_cp_gen_tabl_curr_qty.
ENDINTERFACE.
