INTERFACE if_xco_gen_bdef_s_fo_b_validtn PUBLIC.
  TYPES tt_trigger_operations TYPE STANDARD TABLE OF REF TO object WITH DEFAULT KEY.

  METHODS set_time
    IMPORTING io_time              TYPE REF TO object
    RETURNING VALUE(ro_validation) TYPE REF TO if_xco_gen_bdef_s_fo_b_validtn.
  METHODS set_trigger_operations
    IMPORTING it_trigger_operations TYPE tt_trigger_operations OPTIONAL
    RETURNING VALUE(ro_validation)  TYPE REF TO if_xco_gen_bdef_s_fo_b_validtn.
ENDINTERFACE.
