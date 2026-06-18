INTERFACE if_xco_package PUBLIC.

  TYPES: BEGIN OF ts_object_property,
           application_component       TYPE REF TO if_xco_application_component,
           super_package               TYPE REF TO if_xco_package,
           package_type                TYPE REF TO cl_xco_pkg_type,
           adding_objects_not_possible TYPE abap_bool,
           encapsulated                TYPE abap_bool,
           transport_layer             TYPE REF TO if_xco_transport_layer,
           software_component          TYPE REF TO if_xco_software_component,
           record_object_changes       TYPE abap_bool,
         END OF ts_object_property.

  TYPES: BEGIN OF ts_object,
           property TYPE ts_object_property,
         END OF ts_object.

  METHODS read
      RETURNING
        VALUE(rs_package) TYPE ts_object.

  METHODS exists
    RETURNING
      VALUE(rv_exists) TYPE abap_bool.

ENDINTERFACE.
