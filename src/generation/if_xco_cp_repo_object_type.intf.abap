INTERFACE if_xco_cp_repo_object_type PUBLIC.
  METHODS for
    IMPORTING iv_name          TYPE csequence
    RETURNING VALUE(ro_object) TYPE REF TO if_xco_cp_repository_object.
ENDINTERFACE.
