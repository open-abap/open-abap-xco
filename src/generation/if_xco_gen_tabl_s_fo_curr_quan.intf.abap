INTERFACE if_xco_gen_tabl_s_fo_curr_quan PUBLIC.
  METHODS set_reference_table
    IMPORTING
      iv_table                    TYPE csequence
    RETURNING
      VALUE(ro_currency_quantity) TYPE REF TO if_xco_gen_tabl_s_fo_curr_quan.
  METHODS set_reference_field
    IMPORTING
      iv_field                    TYPE csequence
    RETURNING
      VALUE(ro_currency_quantity) TYPE REF TO if_xco_gen_tabl_s_fo_curr_quan.
ENDINTERFACE.
