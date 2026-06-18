INTERFACE if_xco_cp_repository_factory PUBLIC.
  DATA devc TYPE REF TO if_xco_cp_repo_object_type READ-ONLY.
  DATA tabl TYPE REF TO if_xco_cp_repo_object_type READ-ONLY.
  DATA clas TYPE REF TO if_xco_cp_repo_object_type READ-ONLY.
  DATA ddls TYPE REF TO if_xco_cp_repo_object_type READ-ONLY.
  DATA ddlx TYPE REF TO if_xco_cp_repo_object_type READ-ONLY.
  DATA bdef TYPE REF TO if_xco_cp_repo_object_type READ-ONLY.
  DATA srvd TYPE REF TO if_xco_cp_repo_object_type READ-ONLY.
  DATA srvb TYPE REF TO if_xco_cp_repo_object_type READ-ONLY.
ENDINTERFACE.
