CLASS ltcl_read DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_two,
        first  TYPE i,
        second TYPE i,
      END OF ty_two.
    TYPES ty_twos TYPE STANDARD TABLE OF ty_two WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_five,
        a TYPE i,
        b TYPE i,
        c TYPE i,
        d TYPE i,
        e TYPE i,
      END OF ty_five.
    TYPES ty_fives TYPE STANDARD TABLE OF ty_five WITH EMPTY KEY.

    DATA mo_worksheet TYPE REF TO if_xco_xlsx_ra_worksheet.

    METHODS setup.

    METHODS bounded_rectangle FOR TESTING.
    METHODS unbounded_at_the_bottom FOR TESTING.
    METHODS unbounded_bottom_and_right FOR TESTING.
    METHODS single_column FOR TESTING.
    METHODS stop_after_last_row FOR TESTING.
    METHODS lines_are_appended FOR TESTING.
    METHODS string_value FOR TESTING.
    METHODS no_table FOR TESTING.
    METHODS nested_component FOR TESTING.
    METHODS text_into_number FOR TESTING.
    METHODS not_implemented FOR TESTING.

    METHODS read
      IMPORTING
        io_pattern TYPE REF TO if_xco_xlsx_slc_pattern
        ir_rows    TYPE REF TO data.
ENDCLASS.

CLASS ltcl_write DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_row,
        text   TYPE string,
        number TYPE i,
        amount TYPE p LENGTH 9 DECIMALS 2,
        date   TYPE d,
        flag   TYPE abap_bool,
      END OF ty_row.
    TYPES ty_rows TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mo_document TYPE REF TO if_xco_xlsx_wa_document.
    DATA mo_worksheet TYPE REF TO if_xco_xlsx_wa_worksheet.

    METHODS setup.

    METHODS row_stream FOR TESTING.
    METHODS bounds FOR TESTING.
    METHODS elementary_lines FOR TESTING.
    METHODS sorted_table FOR TESTING.
    METHODS unsupported_type FOR TESTING.
    METHODS nested_component FOR TESTING.
    METHODS no_table FOR TESTING.

    METHODS write
      IMPORTING
        io_pattern TYPE REF TO if_xco_xlsx_slc_pattern
        ir_rows    TYPE REF TO data.

    METHODS assert_cell
      IMPORTING
        iv_column TYPE i
        iv_row    TYPE i
        iv_type   TYPE cl_xco_xlsx_file=>ty_type
        iv_value  TYPE string.

    METHODS saved
      RETURNING
        VALUE(ro_file) TYPE REF TO cl_xco_xlsx_file.
ENDCLASS.

CLASS ltcl_pattern DEFINITION FINAL FOR TESTING.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING
        iv_from_column    TYPE string OPTIONAL
        iv_to_column      TYPE string OPTIONAL
        iv_from_row       TYPE i OPTIONAL
        iv_to_row         TYPE i OPTIONAL
      RETURNING
        VALUE(ro_pattern) TYPE REF TO if_xco_xlsx_slc_pattern.
ENDCLASS.

CLASS ltcl_pattern IMPLEMENTATION.
  METHOD create.
    DATA(lo_builder) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( ).
    IF iv_from_column IS NOT INITIAL.
      lo_builder->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( iv_from_column ) ).
    ENDIF.
    IF iv_to_column IS NOT INITIAL.
      lo_builder->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( iv_to_column ) ).
    ENDIF.
    IF iv_from_row IS NOT INITIAL.
      lo_builder->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( iv_from_row ) ).
    ENDIF.
    IF iv_to_row IS NOT INITIAL.
      lo_builder->to_row( xco_cp_xlsx=>coordinate->for_numeric_value( iv_to_row ) ).
    ENDIF.
    ro_pattern = lo_builder->get_pattern( ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_read IMPLEMENTATION.
  METHOD setup.
    " the worksheet of the SAP Help Portal, "XLSX", "Selection patterns": B2:E5 hold 1 to 16,
    " and further 99 in B8 and a text in Z8
    DATA(lo_file) = cl_xco_xlsx_file=>empty( ).
    DO 16 TIMES.
      lo_file->set_cell( VALUE #( sheet  = 1
                                  row    = ( sy-index - 1 ) DIV 4 + 2
                                  column = ( sy-index - 1 ) MOD 4 + 2
                                  type   = cl_xco_xlsx_file=>gc_type-number
                                  value  = |{ sy-index }| ) ).
    ENDDO.
    lo_file->set_cell( VALUE #( sheet = 1 row = 8 column = 2 type = cl_xco_xlsx_file=>gc_type-number value = `99` ) ).
    lo_file->set_cell( VALUE #( sheet = 1 row = 8 column = 26 type = cl_xco_xlsx_file=>gc_type-string value = `text` ) ).

    DATA(lo_workbook) = xco_cp_xlsx=>document->for_file_content( lo_file->save( ) )->read_access( )->get_workbook( ).
    mo_worksheet = lo_workbook->worksheet->at_position( 1 ).
  ENDMETHOD.

  METHOD bounded_rectangle.
    DATA lt_rows TYPE ty_twos.

    read( io_pattern = ltcl_pattern=>create( iv_from_column = `C`
                                             iv_to_column   = `D`
                                             iv_from_row    = 3
                                             iv_to_row      = 4 )
          ir_rows    = REF #( lt_rows ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_rows
                                        exp = VALUE ty_twos( ( first = 6 second = 7 ) ( first = 10 second = 11 ) ) ).
  ENDMETHOD.

  METHOD unbounded_at_the_bottom.
    DATA lt_rows TYPE ty_twos.

    read( io_pattern = ltcl_pattern=>create( iv_from_column = `C`
                                             iv_to_column   = `D`
                                             iv_from_row    = 3 )
          ir_rows    = REF #( lt_rows ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_rows
                                        exp = VALUE ty_twos( ( first = 6 second = 7 )
                                                             ( first = 10 second = 11 )
                                                             ( first = 14 second = 15 ) ) ).
  ENDMETHOD.

  METHOD unbounded_bottom_and_right.
    DATA lt_rows TYPE ty_fives.

    read( io_pattern = ltcl_pattern=>create( iv_from_column = `C`
                                             iv_from_row    = 3 )
          ir_rows    = REF #( lt_rows ) ).

    " up to row 8 because of Z8, which is right of the fields
    cl_abap_unit_assert=>assert_equals( act = lt_rows
                                        exp = VALUE ty_fives( ( a = 6 b = 7 c = 8 )
                                                              ( a = 10 b = 11 c = 12 )
                                                              ( a = 14 b = 15 c = 16 )
                                                              ( ) ( ) ( ) ) ).
  ENDMETHOD.

  METHOD single_column.
    DATA lt_texts TYPE string_table.

    read( io_pattern = ltcl_pattern=>create( iv_to_column = `A` )
          ir_rows    = REF #( lt_texts ) ).
    cl_abap_unit_assert=>assert_initial( lt_texts ).

    read( io_pattern = ltcl_pattern=>create( iv_from_column = `B`
                                             iv_to_column   = `B` )
          ir_rows    = REF #( lt_texts ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_texts
                                        exp = VALUE string_table( ( `` ) ( `1` ) ( `5` ) ( `9` ) ( `13` ) ( `` ) ( `` )
                                                                  ( `99` ) ) ).
  ENDMETHOD.

  METHOD stop_after_last_row.
    DATA lt_rows TYPE ty_fives.

    read( io_pattern = ltcl_pattern=>create( )
          ir_rows    = REF #( lt_rows ) ).

    " rows 6 and 7 are empty lines
    cl_abap_unit_assert=>assert_equals( act = lines( lt_rows )
                                        exp = 8 ).
    cl_abap_unit_assert=>assert_equals( act = lt_rows[ 2 ]
                                        exp = VALUE ty_five( b = 1 c = 2 d = 3 e = 4 ) ).
    cl_abap_unit_assert=>assert_initial( lt_rows[ 7 ] ).
    cl_abap_unit_assert=>assert_equals( act = lt_rows[ 8 ]
                                        exp = VALUE ty_five( b = 99 ) ).
  ENDMETHOD.

  METHOD lines_are_appended.
    DATA(lt_rows) = VALUE ty_twos( ( first = 99 ) ).

    read( io_pattern = ltcl_pattern=>create( iv_from_column = `B`
                                             iv_from_row    = 5
                                             iv_to_row      = 5 )
          ir_rows    = REF #( lt_rows ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_rows
                                        exp = VALUE ty_twos( ( first = 99 ) ( first = 13 second = 14 ) ) ).
  ENDMETHOD.

  METHOD string_value.
    DATA lt_texts TYPE string_table.

    DATA(lo_row_stream) = mo_worksheet->select( ltcl_pattern=>create( iv_from_column = `E`
                                                                      iv_to_column   = `E`
                                                                      iv_from_row    = 4 ) )->row_stream( ).
    lo_row_stream->operation->write_to( REF #( lt_texts )
      )->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
      )->execute( ).

    cl_abap_unit_assert=>assert_equals( act = lt_texts
                                        exp = VALUE string_table( ( `12` ) ( `16` ) ) ).
  ENDMETHOD.

  METHOD no_table.
    DATA lv_text TYPE string.
    DATA lr_unbound TYPE REF TO data.

    TRY.
        read( io_pattern = ltcl_pattern=>create( )
              ir_rows    = REF #( lv_text ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
    TRY.
        read( io_pattern = ltcl_pattern=>create( )
              ir_rows    = lr_unbound ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD nested_component.
    TYPES:
      BEGIN OF ty_nested,
        first TYPE i,
        inner TYPE ty_two,
      END OF ty_nested.
    TYPES ty_nesteds TYPE STANDARD TABLE OF ty_nested WITH EMPTY KEY.
    DATA lt_rows TYPE ty_nesteds.

    TRY.
        read( io_pattern = ltcl_pattern=>create( iv_from_column = `B` )
              ir_rows    = REF #( lt_rows ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD text_into_number.
    DATA lt_rows TYPE ty_twos.

    TRY.
        read( io_pattern = ltcl_pattern=>create( iv_from_column = `Z` )
              ir_rows    = REF #( lt_rows ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD not_implemented.
    DATA lt_rows TYPE ty_twos.

    DATA(lo_selection) = mo_worksheet->select( ltcl_pattern=>create( ) ).
    DATA(lo_cell_stream) = lo_selection->cell_stream( ).
    TRY.
        lo_cell_stream->operation->visit( VALUE #( ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    DATA(lo_row_stream) = lo_selection->row_stream( ).
    TRY.
        lo_row_stream->operation->write_to( REF #( lt_rows ) )->get_action( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD read.
    DATA(lo_row_stream) = mo_worksheet->select( io_pattern )->row_stream( ).
    DATA(lo_result) = lo_row_stream->operation->write_to( ir_rows )->if_xco_xlsx_ra_operation~execute( ).
    cl_abap_unit_assert=>assert_true( lo_result->succeeded ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_write IMPLEMENTATION.
  METHOD setup.
    mo_document = xco_cp_xlsx=>document->empty( )->write_access( ).
    DATA(lo_workbook) = mo_document->get_workbook( ).
    mo_worksheet = lo_workbook->worksheet->at_position( 1 ).
  ENDMETHOD.

  METHOD row_stream.
    " components in order from the first column of the selection on, one row per line
    DATA(lt_rows) = VALUE ty_rows( ( text = `first` number = -7 amount = '1234.5' date = '20250120' flag = abap_true )
                                   ( text = `` number = 0 amount = 0 flag = abap_false ) ).

    write( io_pattern = ltcl_pattern=>create( iv_from_column = `B`
                                              iv_from_row    = 3 )
           ir_rows    = REF #( lt_rows ) ).

    assert_cell( iv_column = 2
                 iv_row    = 3
                 iv_type   = cl_xco_xlsx_file=>gc_type-string
                 iv_value  = `first` ).
    assert_cell( iv_column = 3
                 iv_row    = 3
                 iv_type   = cl_xco_xlsx_file=>gc_type-number
                 iv_value  = `-7` ).
    assert_cell( iv_column = 4
                 iv_row    = 3
                 iv_type   = cl_xco_xlsx_file=>gc_type-number
                 iv_value  = `1234.50` ).
    assert_cell( iv_column = 5
                 iv_row    = 3
                 iv_type   = cl_xco_xlsx_file=>gc_type-number
                 iv_value  = `45677` ).
    assert_cell( iv_column = 6
                 iv_row    = 4
                 iv_type   = cl_xco_xlsx_file=>gc_type-boolean
                 iv_value  = `0` ).
    " empty text and initial date write no cell, the rest of the second line does
    cl_abap_unit_assert=>assert_equals( act = lines( saved( )->mt_cells )
                                        exp = 8 ).
  ENDMETHOD.

  METHOD bounds.
    DATA(lt_rows) = VALUE ty_rows( ( text = `a` number = 1 ) ( text = `b` number = 2 ) ( text = `c` number = 3 ) ).

    write( io_pattern = ltcl_pattern=>create( iv_to_column = `A`
                                              iv_to_row    = 2 )
           ir_rows    = REF #( lt_rows ) ).

    cl_abap_unit_assert=>assert_equals( act = lines( saved( )->mt_cells )
                                        exp = 2 ).
    assert_cell( iv_column = 1
                 iv_row    = 2
                 iv_type   = cl_xco_xlsx_file=>gc_type-string
                 iv_value  = `b` ).
  ENDMETHOD.

  METHOD elementary_lines.
    DATA(lt_texts) = VALUE string_table( ( `x` ) ( `y` ) ).

    write( io_pattern = ltcl_pattern=>create( )
           ir_rows    = REF #( lt_texts ) ).

    assert_cell( iv_column = 1
                 iv_row    = 2
                 iv_type   = cl_xco_xlsx_file=>gc_type-string
                 iv_value  = `y` ).
  ENDMETHOD.

  METHOD sorted_table.
    TYPES ty_sorted TYPE SORTED TABLE OF ty_row WITH UNIQUE KEY text.
    DATA lt_sorted TYPE ty_sorted.

    INSERT VALUE #( text = `b` ) INTO TABLE lt_sorted.
    INSERT VALUE #( text = `a` ) INTO TABLE lt_sorted.

    write( io_pattern = ltcl_pattern=>create( iv_to_column = `A` )
           ir_rows    = REF #( lt_sorted ) ).

    assert_cell( iv_column = 1
                 iv_row    = 1
                 iv_type   = cl_xco_xlsx_file=>gc_type-string
                 iv_value  = `a` ).
  ENDMETHOD.

  METHOD unsupported_type.
    TYPES:
      BEGIN OF ty_bytes,
        value TYPE xstring,
      END OF ty_bytes.
    TYPES ty_bytes_table TYPE STANDARD TABLE OF ty_bytes WITH EMPTY KEY.

    DATA(lt_bytes) = VALUE ty_bytes_table( ( value = 'FF' ) ).

    TRY.
        write( io_pattern = ltcl_pattern=>create( )
               ir_rows    = REF #( lt_bytes ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD nested_component.
    TYPES:
      BEGIN OF ty_nested,
        text  TYPE string,
        inner TYPE ty_row,
      END OF ty_nested.
    TYPES ty_nesteds TYPE STANDARD TABLE OF ty_nested WITH EMPTY KEY.

    DATA(lt_rows) = VALUE ty_nesteds( ( text = `a` ) ).

    TRY.
        write( io_pattern = ltcl_pattern=>create( )
               ir_rows    = REF #( lt_rows ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD no_table.
    DATA(lv_text) = `no table`.

    TRY.
        write( io_pattern = ltcl_pattern=>create( )
               ir_rows    = REF #( lv_text ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD write.
    DATA(lo_row_stream) = mo_worksheet->select( io_pattern )->row_stream( ).
    DATA(lo_result) = lo_row_stream->operation->write_from( ir_rows )->execute( ).
    cl_abap_unit_assert=>assert_true( lo_result->succeeded ).
  ENDMETHOD.

  METHOD saved.
    ro_file = cl_xco_xlsx_file=>load( mo_document->get_file_content( ) ).
  ENDMETHOD.

  METHOD assert_cell.
    DATA(lo_file) = saved( ).
    READ TABLE lo_file->mt_cells WITH TABLE KEY sheet  = 1
                                                row    = iv_row
                                                column = iv_column INTO DATA(ls_cell).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = ls_cell-type
                                        exp = iv_type ).
    cl_abap_unit_assert=>assert_equals( act = ls_cell-value
                                        exp = iv_value ).
  ENDMETHOD.
ENDCLASS.
