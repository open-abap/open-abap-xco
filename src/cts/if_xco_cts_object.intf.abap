INTERFACE if_xco_cts_object PUBLIC.

  DATA program_id TYPE REF TO cl_xco_cts_program_id READ-ONLY.
  DATA type       TYPE sxco_cts_object_type READ-ONLY.
  DATA name       TYPE sxco_cts_object_name READ-ONLY.

  METHODS get_lock
    RETURNING VALUE(ro_lock) TYPE REF TO if_xco_cts_object_lock.
ENDINTERFACE.
