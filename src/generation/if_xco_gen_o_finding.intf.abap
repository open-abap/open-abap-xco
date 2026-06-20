INTERFACE if_xco_gen_o_finding PUBLIC.
  TYPES tv_object_type TYPE c LENGTH 4.
  TYPES tv_object_name TYPE c LENGTH 40.

  DATA object_type TYPE tv_object_type READ-ONLY.
  DATA object_name TYPE tv_object_name READ-ONLY.
  DATA message TYPE REF TO if_xco_message READ-ONLY.
ENDINTERFACE.
