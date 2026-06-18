INTERFACE if_xco_ddl_field PUBLIC.
  METHODS of_projection RETURNING VALUE(ro_field) TYPE REF TO if_xco_ddl_field.
  METHODS of IMPORTING iv_name TYPE csequence RETURNING VALUE(ro_field) TYPE REF TO if_xco_ddl_field.
  METHODS eq IMPORTING io_field TYPE REF TO if_xco_ddl_field RETURNING VALUE(ro_field) TYPE REF TO if_xco_ddl_field.
  METHODS and IMPORTING io_field TYPE REF TO if_xco_ddl_field RETURNING VALUE(ro_field) TYPE REF TO if_xco_ddl_field.
ENDINTERFACE.
