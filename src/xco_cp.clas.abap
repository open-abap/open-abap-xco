CLASS xco_cp DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA sy TYPE REF TO if_xco_cp_std_sy READ-ONLY.

    CLASS-METHODS class_constructor.

    CLASS-METHODS message
      IMPORTING
        is_message        TYPE symsg
      RETURNING
        VALUE(ro_message) TYPE REF TO if_xco_message.

    CLASS-METHODS uuid
      IMPORTING
        iv_value       TYPE sysuuid_x16 OPTIONAL
      RETURNING
        VALUE(ro_uuid) TYPE REF TO if_xco_uuid.

    CLASS-METHODS string
      IMPORTING
        iv_value         TYPE csequence
      RETURNING
        VALUE(ro_string) TYPE REF TO if_xco_string.
ENDCLASS.

CLASS xco_cp IMPLEMENTATION.
  METHOD class_constructor.
    xco_cp=>sy = NEW cl_xco_cp_std_sy( ).
  ENDMETHOD.

  METHOD message.
    ro_message = NEW cl_xco_message( is_message ).
  ENDMETHOD.

  METHOD uuid.
    IF iv_value IS SUPPLIED.
      ro_uuid = NEW cl_xco_uuid( iv_value ).
    ELSE.
      TRY.
          ro_uuid = NEW cl_xco_uuid( cl_system_uuid=>create_uuid_x16_static( ) ).
        CATCH cx_uuid_error INTO DATA(lx_uuid_error).
          RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_uuid_error ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD string.
    CLEAR ro_string.
  ENDMETHOD.
ENDCLASS.
