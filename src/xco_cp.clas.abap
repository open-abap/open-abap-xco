CLASS xco_cp DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-DATA sy TYPE REF TO if_xco_cp_std_sy READ-ONLY.

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
  METHOD message.
    ro_message = NEW cl_xco_message( is_message ).
  ENDMETHOD.

  METHOD uuid.
    CLEAR ro_uuid.
  ENDMETHOD.

  METHOD string.
    CLEAR ro_string.
  ENDMETHOD.
ENDCLASS.
