INTERFACE if_xco_cp_repository_object PUBLIC.
  METHODS exists
    IMPORTING io_origin        TYPE string OPTIONAL
    RETURNING VALUE(rv_exists) TYPE abap_bool.
  METHODS read
    RETURNING VALUE(rs_object) TYPE if_xco_package=>ts_object.
ENDINTERFACE.
