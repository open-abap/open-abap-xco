INTERFACE if_xco_cp_gen_devc_s_props PUBLIC.
  METHODS set_super_package
    IMPORTING iv_super_package     TYPE csequence
    RETURNING VALUE(ro_properties) TYPE REF TO if_xco_cp_gen_devc_s_props.

  METHODS set_software_component
    IMPORTING iv_software_component TYPE csequence
    RETURNING VALUE(ro_properties)  TYPE REF TO if_xco_cp_gen_devc_s_props.
ENDINTERFACE.
