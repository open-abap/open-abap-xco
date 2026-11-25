CLASS lcl_caller DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS stack_lines
      RETURNING
        VALUE(rt_lines) TYPE string_table.

    CLASS-METHODS take
      RETURNING
        VALUE(ro_call_stack) TYPE REF TO if_xco_cp_call_stack.

    CLASS-METHODS lines_of
      IMPORTING
        io_text         TYPE REF TO if_xco_text
      RETURNING
        VALUE(rt_lines) TYPE string_table.
ENDCLASS.

CLASS lcl_caller IMPLEMENTATION.
  METHOD stack_lines.
    rt_lines = lines_of( xco_cp=>current->call_stack->full( )->as_text( xco_cp_call_stack=>format->adt( ) ) ).
  ENDMETHOD.

  METHOD take.
    ro_call_stack = xco_cp=>current->call_stack->full( ).
  ENDMETHOD.

  METHOD lines_of.
    DATA(lo_lines) = io_text->get_lines( ).
    rt_lines = lo_lines->value.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_call_stack DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS first_frame_is_caller FOR TESTING.
    METHODS innermost_first FOR TESTING.
    METHODS taken_when_full_called FOR TESTING.
    METHODS line_number_flavors FOR TESTING.
    METHODS format_is_its_implementation FOR TESTING.
ENDCLASS.

CLASS ltcl_call_stack IMPLEMENTATION.
  METHOD first_frame_is_caller.
    DATA(lo_format) = xco_cp_call_stack=>format->adt( )->with_line_number_flavor(
      xco_cp_call_stack=>line_number_flavor->include ).

    DATA(lt_lines) = lcl_caller=>lines_of( xco_cp=>current->call_stack->full( )->as_text( lo_format ) ).

    cl_abap_unit_assert=>assert_equals(
      act = VALUE string( lt_lines[ 1 ] OPTIONAL )
      exp = `XCO_CP_CALL_STACK [system]    first_frame_is_caller [method]` ).
  ENDMETHOD.

  METHOD innermost_first.
    DATA(lt_lines) = lcl_caller=>stack_lines( ).

    cl_abap_unit_assert=>assert_equals(
      act = VALUE string( lt_lines[ 1 ] OPTIONAL )
      exp = `XCO_CP_CALL_STACK [system]    stack_lines [method]` ).
    cl_abap_unit_assert=>assert_equals(
      act = VALUE string( lt_lines[ 2 ] OPTIONAL )
      exp = `XCO_CP_CALL_STACK [system]    innermost_first [method]` ).
  ENDMETHOD.

  METHOD taken_when_full_called.
    DATA(lo_call_stack) = lcl_caller=>take( ).

    DATA(lt_lines) = lcl_caller=>lines_of( lo_call_stack->as_text( xco_cp_call_stack=>format->adt( ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = VALUE string( lt_lines[ 1 ] OPTIONAL )
      exp = `XCO_CP_CALL_STACK [system]    take [method]` ).
  ENDMETHOD.

  METHOD line_number_flavors.
    DATA(lo_include) = xco_cp_call_stack=>format->adt( )->with_line_number_flavor(
      xco_cp_call_stack=>line_number_flavor->include ).
    DATA(lo_source) = xco_cp_call_stack=>format->adt( )->with_line_number_flavor(
      xco_cp_call_stack=>line_number_flavor->source ).
    DATA(lo_call_stack) = xco_cp=>current->call_stack->full( ).

    cl_abap_unit_assert=>assert_true( xsdbool(
      xco_cp_call_stack=>line_number_flavor->include <> xco_cp_call_stack=>line_number_flavor->source ) ).
    DATA(lt_include) = lcl_caller=>lines_of( lo_call_stack->as_text( lo_include ) ).
    DATA(lt_source) = lcl_caller=>lines_of( lo_call_stack->as_text( lo_source ) ).

    cl_abap_unit_assert=>assert_not_initial( lt_include ).
    cl_abap_unit_assert=>assert_equals(
      act = lt_include
      exp = lt_source ).
  ENDMETHOD.

  METHOD format_is_its_implementation.
    DATA(lo_adt) = xco_cp_call_stack=>format->adt( ).

    cl_abap_unit_assert=>assert_true( xsdbool( lo_adt->with_line_number_flavor(
      xco_cp_call_stack=>line_number_flavor->source ) = lo_adt ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( lo_adt->if_xco_cs_format~get_implementation( ) = lo_adt ) ).
  ENDMETHOD.
ENDCLASS.
