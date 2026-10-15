CLASS ltcl_xlsx DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_booking,
        reference TYPE string,
        booked_on TYPE d,
        amount    TYPE p LENGTH 9 DECIMALS 2,
        quantity  TYPE i,
        cleared   TYPE abap_bool,
      END OF ty_booking.
    TYPES ty_bookings TYPE STANDARD TABLE OF ty_booking WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_header,
        reference TYPE string,
        booked_on TYPE string,
        amount    TYPE string,
        quantity  TYPE string,
        cleared   TYPE string,
      END OF ty_header.
    TYPES ty_headers TYPE STANDARD TABLE OF ty_header WITH EMPTY KEY.
    TYPES ty_contents TYPE STANDARD TABLE OF xstring WITH EMPTY KEY.

    METHODS round_trip FOR TESTING.
    METHODS two_worksheets FOR TESTING.
    METHODS special_characters FOR TESTING.
    METHODS invalid_file_content FOR TESTING.

    METHODS write
      IMPORTING
        io_worksheet TYPE REF TO if_xco_xlsx_wa_worksheet
        iv_from_row  TYPE i
        ir_rows      TYPE REF TO data.

    METHODS read
      IMPORTING
        io_worksheet TYPE REF TO if_xco_xlsx_ra_worksheet
        iv_from_row  TYPE i
        iv_to_row    TYPE i OPTIONAL
        ir_rows      TYPE REF TO data.
ENDCLASS.

CLASS ltcl_xlsx IMPLEMENTATION.
  METHOD round_trip.
    " a header row of texts, typed rows below it
    DATA lt_headers TYPE ty_headers.
    DATA lt_bookings TYPE ty_bookings.

    DATA(lt_expected_headers) = VALUE ty_headers( ( reference = `Reference` booked_on = `Booked on` amount = `Amount`
                                                    quantity = `Quantity` cleared = `Cleared` ) ).
    DATA(lt_expected) = VALUE ty_bookings(
      ( reference = `B-1` booked_on = '20250120' amount = '1234.56' quantity = 3 cleared = abap_true )
      ( reference = `B-2` booked_on = '20260731' amount = '-99.00' quantity = -1 )
      ( reference = `B-3` ) ).

    DATA(lo_document) = xco_cp_xlsx=>document->empty( )->write_access( ).
    DATA(lo_write_workbook) = lo_document->get_workbook( ).
    DATA(lo_write_sheet) = lo_write_workbook->worksheet->at_position( 1 ).
    write( io_worksheet = lo_write_sheet
           iv_from_row  = 1
           ir_rows      = REF #( lt_expected_headers ) ).
    write( io_worksheet = lo_write_sheet
           iv_from_row  = 2
           ir_rows      = REF #( lt_expected ) ).

    DATA(lo_workbook) = xco_cp_xlsx=>document->for_file_content( lo_document->get_file_content( )
      )->read_access( )->get_workbook( ).
    DATA(lo_sheet) = lo_workbook->worksheet->for_name( `Sheet1` ).
    read( io_worksheet = lo_sheet
          iv_from_row  = 1
          iv_to_row    = 1
          ir_rows      = REF #( lt_headers ) ).
    read( io_worksheet = lo_sheet
          iv_from_row  = 2
          ir_rows      = REF #( lt_bookings ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_headers
                                        exp = lt_expected_headers ).
    cl_abap_unit_assert=>assert_equals( act = lt_bookings
                                        exp = lt_expected ).
  ENDMETHOD.

  METHOD two_worksheets.
    DATA lt_read TYPE string_table.

    DATA(lo_document) = xco_cp_xlsx=>document->empty( )->write_access( ).
    DATA(lo_write_workbook) = lo_document->get_workbook( ).
    lo_write_workbook->worksheet->at_position( 1 )->set_name( `Employees` ).
    DATA(lt_archive) = VALUE string_table( ( `old` ) ( `older` ) ).
    write( io_worksheet = lo_write_workbook->add_new_sheet( `Archive` )
           iv_from_row  = 1
           ir_rows      = REF #( lt_archive ) ).

    DATA(lo_workbook) = xco_cp_xlsx=>document->for_file_content( lo_document->get_file_content( )
      )->read_access( )->get_workbook( ).

    cl_abap_unit_assert=>assert_true( lo_workbook->worksheet->for_name( `Employees` )->exists( ) ).
    cl_abap_unit_assert=>assert_false( lo_workbook->worksheet->at_position( 3 )->exists( ) ).
    read( io_worksheet = lo_workbook->worksheet->at_position( 2 )
          iv_from_row  = 1
          ir_rows      = REF #( lt_read ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_read
                                        exp = lt_archive ).
  ENDMETHOD.

  METHOD special_characters.
    DATA lt_read TYPE string_table.

    DATA(lt_texts) = VALUE string_table( ( `<tag attribute="1">&amp;</tag>` )
                                         ( cl_abap_conv_codepage=>create_in( )->convert( CONV xstring( 'CEA9CEBCCEADCEB3CEB120E282AC' ) ) )
                                         ( `  spaces around  ` ) ).

    DATA(lo_document) = xco_cp_xlsx=>document->empty( )->write_access( ).
    DATA(lo_write_workbook) = lo_document->get_workbook( ).
    write( io_worksheet = lo_write_workbook->worksheet->at_position( 1 )
           iv_from_row  = 1
           ir_rows      = REF #( lt_texts ) ).
    DATA(lo_workbook) = xco_cp_xlsx=>document->for_file_content( lo_document->get_file_content( )
      )->read_access( )->get_workbook( ).
    read( io_worksheet = lo_workbook->worksheet->at_position( 1 )
          iv_from_row  = 1
          ir_rows      = REF #( lt_read ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_read
                                        exp = lt_texts ).
  ENDMETHOD.

  METHOD invalid_file_content.
    DATA(lo_zip) = NEW cl_abap_zip( ).
    lo_zip->add( name    = `readme.txt`
                 content = CONV xstring( '41' ) ).
    DATA(lt_contents) = VALUE ty_contents( ( CONV xstring( 'FFFEFDFC' ) ) ( lo_zip->save( ) ) ( ) ).

    LOOP AT lt_contents INTO DATA(lv_content).
      TRY.
          xco_cp_xlsx=>document->for_file_content( lv_content )->read_access( ).
          cl_abap_unit_assert=>fail( ).
        CATCH cx_xco_runtime_exception ##NO_HANDLER.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD write.
    DATA(lo_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
      )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( iv_from_row )
      )->get_pattern( ).
    DATA(lo_row_stream) = io_worksheet->select( lo_pattern )->row_stream( ).
    lo_row_stream->operation->write_from( ir_rows )->execute( ).
  ENDMETHOD.

  METHOD read.
    DATA(lo_builder) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
      )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( iv_from_row ) ).
    IF iv_to_row IS NOT INITIAL.
      lo_builder->to_row( xco_cp_xlsx=>coordinate->for_numeric_value( iv_to_row ) ).
    ENDIF.
    DATA(lo_row_stream) = io_worksheet->select( lo_builder->get_pattern( ) )->row_stream( ).
    lo_row_stream->operation->write_to( ir_rows )->execute( ).
  ENDMETHOD.
ENDCLASS.
