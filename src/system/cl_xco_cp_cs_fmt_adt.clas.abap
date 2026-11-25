CLASS cl_xco_cp_cs_fmt_adt DEFINITION PUBLIC FINAL INHERITING FROM cl_xco_cs_format CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_cp_cs_format_factory.

  PUBLIC SECTION.
    METHODS with_line_number_flavor
      IMPORTING
        io_line_number_flavor TYPE REF TO if_xco_cs_line_number_flavor
      RETURNING
        VALUE(ro_me)          TYPE REF TO cl_xco_cp_cs_fmt_adt.

  PROTECTED SECTION.
    METHODS format_frame REDEFINITION.

  PRIVATE SECTION.
    DATA mo_line_number_flavor TYPE REF TO if_xco_cs_line_number_flavor.
ENDCLASS.

CLASS cl_xco_cp_cs_fmt_adt IMPLEMENTATION.
  METHOD with_line_number_flavor.
    mo_line_number_flavor = io_line_number_flavor.
    ro_me = me.
  ENDMETHOD.

  METHOD format_frame.
    " one line per frame, "ZCL_ORDER_SERVICE    zif_order_service~cancel [method]", with "[system]"
    " after the object of a system frame; on a system the line number of the flavor follows, the
    " transpiled code has no ABAP line numbers, so the line ends after the kind of the event
    rv_line = is_frame-object.
    IF is_frame-is_system = abap_true.
      rv_line = |{ rv_line } [system]|.
    ENDIF.
    rv_line = |{ rv_line }    { is_frame-event } [{ is_frame-event_type }]|.
  ENDMETHOD.
ENDCLASS.
