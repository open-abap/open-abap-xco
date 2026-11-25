INTERFACE if_xco_cp_ar_tabl_object_list PUBLIC.
  INTERFACES if_xco_cp_ar_api_object_list.

  ALIASES all FOR if_xco_cp_ar_api_object_list~all.
  ALIASES where FOR if_xco_cp_ar_api_object_list~where.

  DATA database_tables TYPE REF TO if_xco_cp_ar_api_object_list READ-ONLY.
  DATA structures TYPE REF TO if_xco_cp_ar_api_object_list READ-ONLY.
ENDINTERFACE.
