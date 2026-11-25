CLASS cl_xco_cp_uuid_format_factory DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_uuid.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_uuid_format_factory.

    METHODS constructor.
ENDCLASS.

CLASS cl_xco_cp_uuid_format_factory IMPLEMENTATION.
  METHOD constructor.
    if_xco_cp_uuid_format_factory~c22 = NEW lcl_format( lcl_format=>c_length-c22 ).
    if_xco_cp_uuid_format_factory~c32 = NEW lcl_format( lcl_format=>c_length-c32 ).
    if_xco_cp_uuid_format_factory~c36 = NEW lcl_format( lcl_format=>c_length-c36 ).
  ENDMETHOD.
ENDCLASS.
