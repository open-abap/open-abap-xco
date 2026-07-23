INTERFACE if_xco_cp_bal_log PUBLIC.
  METHODS add_text
    IMPORTING
      io_text            TYPE REF TO if_xco_text
      io_level_of_detail TYPE REF TO cl_xco_bal_level_of_detail OPTIONAL.

  METHODS add_message
    IMPORTING
      is_symsg           TYPE symsg
      io_level_of_detail TYPE REF TO cl_xco_bal_level_of_detail OPTIONAL.

  METHODS add_exception
    IMPORTING
      ix_exception       TYPE REF TO cx_root
      io_severity        TYPE REF TO cl_xco_message_type OPTIONAL
      io_level_of_detail TYPE REF TO cl_xco_bal_level_of_detail OPTIONAL
      io_descent         TYPE REF TO if_xco_cp_bal_exc_descent OPTIONAL
      it_additions       TYPE sxco_t_cp_bal_exc_additions OPTIONAL.
ENDINTERFACE.
