INTERFACE if_abap_behv PUBLIC.
  CONSTANTS:
    BEGIN OF mk,
      on  TYPE abap_bool VALUE abap_true,
      off TYPE abap_bool VALUE abap_false,
    END OF mk.
ENDINTERFACE.
