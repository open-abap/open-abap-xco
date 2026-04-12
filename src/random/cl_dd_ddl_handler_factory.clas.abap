CLASS cl_dd_ddl_handler_factory DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create
      RETURNING
        VALUE(handler) TYPE REF TO if_dd_ddl_handler.

ENDCLASS.

CLASS cl_dd_ddl_handler_factory IMPLEMENTATION.
  METHOD create.
    RETURN. " todo, implement method
  ENDMETHOD.

ENDCLASS.