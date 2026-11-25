CLASS xco_cp_behavior_definition DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA standard_operation TYPE REF TO cl_xco_bdef_standard_op_f READ-ONLY.
    CLASS-DATA evaluation TYPE REF TO cl_xco_bdef_evaluation_f READ-ONLY.
    CLASS-DATA implementation_type TYPE REF TO cl_xco_bdef_impl_type_f READ-ONLY.
    CLASS-DATA extensible_option TYPE REF TO cl_xco_bdef_extensible_opt_f READ-ONLY.
ENDCLASS.

CLASS xco_cp_behavior_definition IMPLEMENTATION.
ENDCLASS.
