CLASS ltcl_file DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS gc_main TYPE string VALUE `http://schemas.openxmlformats.org/spreadsheetml/2006/main`.
    CONSTANTS gc_relationships TYPE string VALUE `http://schemas.openxmlformats.org/officeDocument/2006/relationships`.
    CONSTANTS gc_package TYPE string VALUE `http://schemas.openxmlformats.org/package/2006/relationships`.

    METHODS openpyxl FOR TESTING.
    METHODS libreoffice FOR TESTING.
    METHODS handmade_package FOR TESTING.
    METHODS not_a_zip FOR TESTING.
    METHODS zip_without_workbook FOR TESTING.
    METHODS missing_worksheet FOR TESTING.
    METHODS broken_xml FOR TESTING.
    METHODS round_trip FOR TESTING.
    METHODS shared_strings_and_escaping FOR TESTING.
    METHODS sheet_names FOR TESTING.
    METHODS invalid_sheet_names FOR TESTING.
    METHODS sheet_name_ignores_case FOR TESTING.
    METHODS damaged_zip FOR TESTING.
    METHODS malformed_worksheets FOR TESTING.
    METHODS excel_escapes FOR TESTING.
    METHODS excel_escapes_read FOR TESTING.
    METHODS outside_of_the_grid FOR TESTING.

    " a package with one worksheet of the given sheetData
    METHODS package
      IMPORTING
        iv_sheet_data     TYPE string
        iv_strings        TYPE string OPTIONAL
      RETURNING
        VALUE(rv_content) TYPE xstring.

    METHODS assert_cell
      IMPORTING
        io_file  TYPE REF TO cl_xco_xlsx_file
        iv_sheet TYPE i DEFAULT 1
        iv_cell  TYPE string
        iv_type  TYPE cl_xco_xlsx_file=>ty_type
        iv_value TYPE string.

    METHODS assert_no_cell
      IMPORTING
        io_file  TYPE REF TO cl_xco_xlsx_file
        iv_sheet TYPE i DEFAULT 1
        iv_cell  TYPE string.

    " a cell with row 0 if there is none
    METHODS read_cell
      IMPORTING
        io_file        TYPE REF TO cl_xco_xlsx_file
        iv_sheet       TYPE i
        iv_cell        TYPE string
      RETURNING
        VALUE(rs_cell) TYPE cl_xco_xlsx_file=>ty_cell.

    METHODS utf8
      IMPORTING
        iv_hex         TYPE xstring
      RETURNING
        VALUE(rv_text) TYPE string.

    METHODS assert_load_fails
      IMPORTING
        iv_content TYPE xstring.

    " names and contents alternate
    METHODS zip
      IMPORTING
        it_parts          TYPE string_table
      RETURNING
        VALUE(rv_content) TYPE xstring.

    METHODS part_text
      IMPORTING
        iv_content     TYPE xstring
        iv_name        TYPE string
      RETURNING
        VALUE(rv_text) TYPE string.

    " written by openpyxl 3.1.5: inline strings, absolute relationship targets
    METHODS openpyxl_fixture
      RETURNING
        VALUE(rv_content) TYPE xstring.

    " the openpyxl fixture saved again by LibreOffice Calc: shared strings, formulas,
    " ZIP data descriptors
    METHODS libreoffice_fixture
      RETURNING
        VALUE(rv_content) TYPE xstring.
ENDCLASS.

CLASS ltcl_file IMPLEMENTATION.
  METHOD openpyxl.
    DATA(lo_file) = cl_xco_xlsx_file=>load( openpyxl_fixture( ) ).

    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_count( )
                                        exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `Data` )
                                        exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `Second & <more>` )
                                        exp = 2 ).

    assert_cell( io_file  = lo_file
                 iv_cell  = `A1`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `Name` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `A2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = utf8( 'C39C6EC3AF63C3B664C3A920E282AC' ) ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `B2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-number
                 iv_value = `1234.5` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `C2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-boolean
                 iv_value = `1` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `D3`
                 iv_type  = cl_xco_xlsx_file=>gc_type-number
                 iv_value = `46234` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `B3`
                 iv_type  = cl_xco_xlsx_file=>gc_type-number
                 iv_value = `-7` ).
    assert_no_cell( io_file = lo_file
                    iv_cell = `A4` ).
    assert_no_cell( io_file = lo_file
                    iv_cell = `B5` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `C5`
                 iv_type  = cl_xco_xlsx_file=>gc_type-number
                 iv_value = `0.25` ).
    assert_cell( io_file  = lo_file
                 iv_sheet = 2
                 iv_cell  = `B2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `x<y & "z"` ).
    cl_abap_unit_assert=>assert_equals( act = lines( lo_file->mt_cells )
                                        exp = 17 ).
  ENDMETHOD.

  METHOD libreoffice.
    DATA(lo_file) = cl_xco_xlsx_file=>load( libreoffice_fixture( ) ).

    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `Second & <more>` )
                                        exp = 2 ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `A2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = utf8( 'C39C6EC3AF63C3B664C3A920E282AC' ) ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `C2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-boolean
                 iv_value = `1` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `D2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-number
                 iv_value = `45677` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `A5`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `after gap` ).
    assert_cell( io_file  = lo_file
                 iv_sheet = 2
                 iv_cell  = `C3`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `Plain` ).
    cl_abap_unit_assert=>assert_equals( act = lines( lo_file->mt_cells )
                                        exp = 17 ).
  ENDMETHOD.

  METHOD handmade_package.
    " a non-standard workbook path, sheets listed in another order than their parts,
    " rich text, phonetic hints, prefixed elements and cells without r
    DATA(lv_root) = |<Relationships xmlns="{ gc_package }">|
                 && |<Relationship Id="r1" Target="/custom/book.xml" Type="{ gc_relationships }/officeDocument"/>|
                 && `</Relationships>`.
    DATA(lv_book) = |<x:workbook xmlns:x="{ gc_main }" xmlns:r="{ gc_relationships }"><x:sheets>|
                 && `<x:sheet name="First" sheetId="7" r:id="rIdB"/><x:sheet name="Second" sheetId="3" r:id="rIdA"/>`
                 && `</x:sheets></x:workbook>`.
    DATA(lv_book_rels) = |<Relationships xmlns="{ gc_package }">|
                      && |<Relationship Id="rIdA" Type="{ gc_relationships }/worksheet" Target="sheets/a.xml"/>|
                      && |<Relationship Id="rIdB" Type="{ gc_relationships }/worksheet" Target="../custom/sheets/b.xml"/>|
                      && |<Relationship Id="rIdS" Type="{ gc_relationships }/sharedStrings" Target="strings.xml"/>|
                      && `</Relationships>`.
    DATA(lv_strings) = |<sst xmlns="{ gc_main }"><si><t>plain</t></si>|
                    && `<si><r><t>rich </t></r><r><rPr><b/></rPr><t>text</t></r><rPh sb="0" eb="1"><t>IGNORED</t></rPh></si>`
                    && `<si><t xml:space="preserve">  spaced  </t></si></sst>`.
    DATA(lv_first) = |<x:worksheet xmlns:x="{ gc_main }"><x:sheetData>|
                  && `<x:row><x:c t="s"><x:v>0</x:v></x:c><x:c t="s"><x:v>1</x:v></x:c></x:row>`
                  && `<x:row r="3"><x:c r="C3" t="inlineStr"><x:is><x:r><x:t>in</x:t></x:r><x:r><x:t>line</x:t></x:r></x:is></x:c>`
                  && `<x:c t="str"><x:f>A1&amp;"!"</x:f><x:v>plain!</x:v></x:c><x:c t="e"><x:v>#DIV/0!</x:v></x:c><x:c s="1"/>`
                  && `</x:row></x:sheetData></x:worksheet>`.
    DATA(lv_second) = |<worksheet xmlns="{ gc_main }"><sheetData><row r="2"><c r="B2" t="s"><v>2</v></c>|
                   && `<c r="C2"><v>-1.5E-3</v></c></row></sheetData></worksheet>`.

    DATA(lo_file) = cl_xco_xlsx_file=>load( zip( VALUE #( ( `_rels/.rels` ) ( lv_root )
                                                         ( `custom/book.xml` ) ( lv_book )
                                                         ( `custom/_rels/book.xml.rels` ) ( lv_book_rels )
                                                         ( `custom/strings.xml` ) ( lv_strings )
                                                         ( `custom/sheets/b.xml` ) ( lv_first )
                                                         ( `custom/sheets/a.xml` ) ( lv_second ) ) ) ).

    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `First` )
                                        exp = 1 ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `A1`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `plain` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `B1`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `rich text` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `C3`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `inline` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `D3`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `plain!` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `E3`
                 iv_type  = cl_xco_xlsx_file=>gc_type-error
                 iv_value = `#DIV/0!` ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `F3`
                 iv_type  = ``
                 iv_value = `` ).
    assert_cell( io_file  = lo_file
                 iv_sheet = 2
                 iv_cell  = `B2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `  spaced  ` ).
    assert_cell( io_file  = lo_file
                 iv_sheet = 2
                 iv_cell  = `C2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-number
                 iv_value = `-1.5E-3` ).
  ENDMETHOD.

  METHOD not_a_zip.
    assert_load_fails( CONV xstring( 'FFFEFDFC' ) ).
  ENDMETHOD.

  METHOD zip_without_workbook.
    assert_load_fails( zip( VALUE #( ( `readme.txt` ) ( `hello` ) ) ) ).
  ENDMETHOD.

  METHOD missing_worksheet.
    DATA(lv_book) = |<workbook xmlns="{ gc_main }" xmlns:r="{ gc_relationships }"><sheets>|
                 && `<sheet name="Sheet1" sheetId="1" r:id="rId1"/></sheets></workbook>`.
    assert_load_fails( zip( VALUE #( ( `xl/workbook.xml` ) ( lv_book ) ) ) ).
  ENDMETHOD.

  METHOD broken_xml.
    DATA(lv_book) = |<workbook xmlns="{ gc_main }"><sheets><sheet name="a"</workbook>|.
    assert_load_fails( zip( VALUE #( ( `xl/workbook.xml` ) ( lv_book ) ) ) ).
  ENDMETHOD.

  METHOD round_trip.
    DATA(lo_file) = cl_xco_xlsx_file=>empty( ).
    lo_file->add_sheet( `Two` ).
    lo_file->set_cell( VALUE #( sheet = 1 row = 1 column = 1 type = cl_xco_xlsx_file=>gc_type-string value = `text` ) ).
    lo_file->set_cell( VALUE #( sheet = 1 row = 1 column = 3 type = cl_xco_xlsx_file=>gc_type-number value = `-12.5` ) ).
    lo_file->set_cell( VALUE #( sheet = 1 row = 4 column = 28 type = cl_xco_xlsx_file=>gc_type-boolean value = `0` ) ).
    lo_file->set_cell( VALUE #( sheet = 2 row = 2 column = 2 type = cl_xco_xlsx_file=>gc_type-number value = `45677`
                                style = cl_xco_xlsx_file=>gc_style-date ) ).
    lo_file->set_cell( VALUE #( sheet = 2 row = 3 column = 2 type = cl_xco_xlsx_file=>gc_type-string value = `removed` ) ).
    lo_file->set_cell( VALUE #( sheet = 2 row = 3 column = 2 ) ).

    DATA(lo_loaded) = cl_xco_xlsx_file=>load( lo_file->save( ) ).

    cl_abap_unit_assert=>assert_equals( act = lo_loaded->get_sheet_position( `Two` )
                                        exp = 2 ).
    assert_cell( io_file  = lo_loaded
                 iv_cell  = `A1`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `text` ).
    assert_cell( io_file  = lo_loaded
                 iv_cell  = `C1`
                 iv_type  = cl_xco_xlsx_file=>gc_type-number
                 iv_value = `-12.5` ).
    assert_cell( io_file  = lo_loaded
                 iv_cell  = `AB4`
                 iv_type  = cl_xco_xlsx_file=>gc_type-boolean
                 iv_value = `0` ).
    assert_cell( io_file  = lo_loaded
                 iv_sheet = 2
                 iv_cell  = `B2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-number
                 iv_value = `45677` ).
    assert_no_cell( io_file  = lo_loaded
                    iv_sheet = 2
                    iv_cell  = `B3` ).
    cl_abap_unit_assert=>assert_equals( act = lines( lo_loaded->mt_cells )
                                        exp = 4 ).
  ENDMETHOD.

  METHOD shared_strings_and_escaping.
    DATA(lv_special) = `a&b <c> "d" ` && utf8( 'CEA9CEBCCEADCEB3CEB1' ).
    DATA(lo_file) = cl_xco_xlsx_file=>empty( ).
    lo_file->set_cell( VALUE #( sheet = 1 row = 1 column = 1 type = cl_xco_xlsx_file=>gc_type-string value = lv_special ) ).
    lo_file->set_cell( VALUE #( sheet = 1 row = 2 column = 1 type = cl_xco_xlsx_file=>gc_type-string value = lv_special ) ).
    lo_file->set_cell( VALUE #( sheet = 1 row = 3 column = 1 type = cl_xco_xlsx_file=>gc_type-string value = ` lead` ) ).
    lo_file->set_sheet_name( iv_position = 1
                             iv_name     = `R&D <"1">` ).

    DATA(lv_content) = lo_file->save( ).

    DATA(lv_strings) = part_text( iv_content = lv_content
                                  iv_name    = `xl/sharedStrings.xml` ).
    cl_abap_unit_assert=>assert_char_cp( act = lv_strings
                                         exp = `*uniqueCount="2"*a&amp;b &lt;c&gt; &quot;d&quot; *` ).
    cl_abap_unit_assert=>assert_char_cp( act = part_text( iv_content = lv_content
                                                          iv_name    = `xl/workbook.xml` )
                                         exp = `*name="R&amp;D &lt;&quot;1&quot;&gt;"*` ).
    cl_abap_unit_assert=>assert_char_cp( act = part_text( iv_content = lv_content
                                                          iv_name    = `xl/worksheets/sheet1.xml` )
                                         exp = `*<c r="A1" t="s"><v>0</v></c>*<c r="A3" t="s"><v>1</v></c>*` ).

    DATA(lo_loaded) = cl_xco_xlsx_file=>load( lv_content ).
    cl_abap_unit_assert=>assert_equals( act = lo_loaded->get_sheet_position( `R&D <"1">` )
                                        exp = 1 ).
    assert_cell( io_file  = lo_loaded
                 iv_cell  = `A2`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = lv_special ).
    assert_cell( io_file  = lo_loaded
                 iv_cell  = `A3`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = ` lead` ).
  ENDMETHOD.

  METHOD sheet_names.
    DATA(lo_file) = cl_xco_xlsx_file=>empty( ).
    lo_file->set_sheet_name( iv_position = 1
                             iv_name     = `Sheet2` ).
    " the first free name
    lo_file->add_sheet( ).
    lo_file->add_sheet( `1234567890123456789012345678901` ).
    lo_file->set_sheet_name( iv_position = 1
                             iv_name     = `SHEET2` ).
    lo_file->add_sheet( `it's` ).

    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `Sheet1` )
                                        exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `1234567890123456789012345678901` )
                                        exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `SHEET2` )
                                        exp = 1 ).
  ENDMETHOD.

  METHOD invalid_sheet_names.
    DATA(lo_file) = cl_xco_xlsx_file=>empty( ).
    DATA(lt_names) = VALUE string_table( ( `12345678901234567890123456789012` ) ( `a/b` ) ( `a[1]` )
                                         ( `what?` ) ( `sheet1` ) ( `'quoted` ) ( `quoted'` ) ( `history` )
                                         ( |a{ cl_abap_char_utilities=>horizontal_tab }b| ) ).

    LOOP AT lt_names INTO DATA(lv_name).
      TRY.
          lo_file->add_sheet( lv_name ).
          cl_abap_unit_assert=>fail( lv_name ).
        CATCH cx_xco_runtime_exception ##NO_HANDLER.
      ENDTRY.
    ENDLOOP.

    TRY.
        lo_file->set_sheet_name( iv_position = 1
                                 iv_name     = `` ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_count( )
                                        exp = 1 ).
  ENDMETHOD.

  METHOD sheet_name_ignores_case.
    DATA(lo_file) = cl_xco_xlsx_file=>empty( ).

    cl_abap_unit_assert=>assert_equals( act = lo_file->get_sheet_position( `SHEET1` )
                                        exp = 1 ).
  ENDMETHOD.

  METHOD damaged_zip.
    " the offset of the local header and the compressed size beyond the end of the file
    CONSTANTS lc_beyond_the_end TYPE x LENGTH 4 VALUE 'FFFFFF00'.
    DATA lv_damaged TYPE xstring.

    DATA(lv_content) = package( `<row r="1"><c r="A1"><v>1</v></c></row>` ).
    DATA(lv_directory) = xstrlen( lv_content ) - 22 - 30.
    WHILE lv_content+lv_directory(4) <> '504B0102'.
      lv_directory = lv_directory - 1.
    ENDWHILE.

    DATA(lv_offset) = lv_directory + 42.
    DATA(lv_after) = lv_offset + 4.
    CONCATENATE lv_content(lv_offset) lc_beyond_the_end lv_content+lv_after INTO lv_damaged IN BYTE MODE.
    assert_load_fails( lv_damaged ).

    lv_offset = lv_directory + 20.
    lv_after = lv_offset + 4.
    CONCATENATE lv_content(lv_offset) lc_beyond_the_end lv_content+lv_after INTO lv_damaged IN BYTE MODE.
    assert_load_fails( lv_damaged ).
  ENDMETHOD.

  METHOD malformed_worksheets.
    assert_load_fails( package( `<row r="x"><c><v>1</v></c></row>` ) ).
    assert_load_fails( package( `<row r="99999999"><c><v>1</v></c></row>` ) ).
    assert_load_fails( package( `<row r="1048577"><c><v>1</v></c></row>` ) ).
    assert_load_fails( package( `<row><c r="A99999999999"><v>1</v></c></row>` ) ).
    assert_load_fails( package( `<row><c r="XFE1"><v>1</v></c></row>` ) ).
    assert_load_fails( package( `<row><c r="1A"><v>1</v></c></row>` ) ).
    assert_load_fails( package( iv_sheet_data = `<row><c t="s"><v>0.5</v></c></row>`
                                iv_strings    = `<si><t>a</t></si>` ) ).
    assert_load_fails( package( iv_sheet_data = `<row><c t="s"><v>1</v></c></row>`
                                iv_strings    = `<si><t>a</t></si>` ) ).
  ENDMETHOD.

  METHOD excel_escapes.
    " characters XML 1.0 cannot hold and carriage returns as _xHHHH_, a literal _xHHHH_ kept
    DATA(lv_text) = |a{ cl_abap_char_utilities=>cr_lf }b{ utf8( '07' ) }c _x0041_ d{ cl_abap_char_utilities=>newline }|.
    DATA(lo_file) = cl_xco_xlsx_file=>empty( ).
    lo_file->set_cell( VALUE #( sheet = 1 row = 1 column = 1 type = cl_xco_xlsx_file=>gc_type-string value = lv_text ) ).

    DATA(lv_content) = lo_file->save( ).

    cl_abap_unit_assert=>assert_char_cp( act = part_text( iv_content = lv_content
                                                          iv_name    = `xl/sharedStrings.xml` )
                                         exp = |*a_x000D_{ cl_abap_char_utilities=>newline }b_x0007_c _x005F_x0041_ d*| ).
    assert_cell( io_file  = cl_xco_xlsx_file=>load( lv_content )
                 iv_cell  = `A1`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = lv_text ).
  ENDMETHOD.

  METHOD excel_escapes_read.
    DATA(lo_file) = cl_xco_xlsx_file=>load( package(
      iv_sheet_data = `<row><c t="s"><v>0</v></c><c t="inlineStr"><is><t>_x00e9_</t></is></c>`
                   && `<c t="str"><v>x_x005F_x0041_</v></c><c><v>_x0041_</v></c></row>`
      iv_strings    = `<si><t>_x0041__x0009_</t></si>` ) ).

    assert_cell( io_file  = lo_file
                 iv_cell  = `A1`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = |A{ cl_abap_char_utilities=>horizontal_tab }| ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `B1`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = utf8( 'C3A9' ) ).
    assert_cell( io_file  = lo_file
                 iv_cell  = `C1`
                 iv_type  = cl_xco_xlsx_file=>gc_type-string
                 iv_value = `x_x0041_` ).
  ENDMETHOD.

  METHOD outside_of_the_grid.
    DATA(lo_file) = cl_xco_xlsx_file=>empty( ).
    lo_file->set_cell( VALUE #( sheet = 1 row = 1048576 column = 16384 type = cl_xco_xlsx_file=>gc_type-number value = `1` ) ).

    TRY.
        lo_file->set_cell( VALUE #( sheet = 1 row = 1048577 column = 1 type = cl_xco_xlsx_file=>gc_type-number value = `1` ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
    TRY.
        lo_file->set_cell( VALUE #( sheet = 1 row = 1 column = 16385 type = cl_xco_xlsx_file=>gc_type-number value = `1` ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.

    assert_cell( io_file  = cl_xco_xlsx_file=>load( lo_file->save( ) )
                 iv_cell  = `XFD1048576`
                 iv_type  = cl_xco_xlsx_file=>gc_type-number
                 iv_value = `1` ).
  ENDMETHOD.

  METHOD package.
    DATA(lv_book) = |<workbook xmlns="{ gc_main }" xmlns:r="{ gc_relationships }"><sheets>|
                 && `<sheet name="Sheet1" sheetId="1" r:id="rId1"/></sheets></workbook>`.
    DATA(lv_rels) = |<Relationships xmlns="{ gc_package }">|
                 && |<Relationship Id="rId1" Type="{ gc_relationships }/worksheet" Target="sheet1.xml"/>|
                 && |<Relationship Id="rId2" Type="{ gc_relationships }/sharedStrings" Target="strings.xml"/>|
                 && `</Relationships>`.
    rv_content = zip( VALUE #( ( `xl/workbook.xml` ) ( lv_book )
                               ( `xl/_rels/workbook.xml.rels` ) ( lv_rels )
                               ( `xl/strings.xml` ) ( |<sst xmlns="{ gc_main }">{ iv_strings }</sst>| )
                               ( `xl/sheet1.xml` )
                               ( |<worksheet xmlns="{ gc_main }"><sheetData>{ iv_sheet_data }</sheetData></worksheet>| ) ) ).
  ENDMETHOD.

  METHOD assert_cell.
    DATA(ls_cell) = read_cell( io_file  = io_file
                               iv_sheet = iv_sheet
                               iv_cell  = iv_cell ).

    cl_abap_unit_assert=>assert_differs( act = ls_cell-row
                                         exp = 0
                                         msg = iv_cell ).
    cl_abap_unit_assert=>assert_equals( act = ls_cell-type
                                        exp = iv_type
                                        msg = iv_cell ).
    cl_abap_unit_assert=>assert_equals( act = ls_cell-value
                                        exp = iv_value
                                        msg = iv_cell ).
  ENDMETHOD.

  METHOD assert_no_cell.
    DATA(ls_cell) = read_cell( io_file  = io_file
                               iv_sheet = iv_sheet
                               iv_cell  = iv_cell ).

    cl_abap_unit_assert=>assert_equals( act = ls_cell-row
                                        exp = 0
                                        msg = iv_cell ).
  ENDMETHOD.

  METHOD read_cell.
    DATA lv_letters TYPE string.
    DATA lv_row TYPE i.

    FIND REGEX `^([A-Z]+)(\d+)$` IN iv_cell SUBMATCHES lv_letters lv_row.
    cl_abap_unit_assert=>assert_subrc( ).
    DATA(lv_column) = xco_cp_xlsx=>coordinate->for_alphabetic_value( lv_letters )->get_numeric_value( ).

    READ TABLE io_file->mt_cells WITH TABLE KEY sheet  = iv_sheet
                                                row    = lv_row
                                                column = lv_column INTO rs_cell.
    IF sy-subrc <> 0.
      CLEAR rs_cell.
    ENDIF.
  ENDMETHOD.

  METHOD utf8.
    rv_text = cl_abap_conv_codepage=>create_in( )->convert( iv_hex ).
  ENDMETHOD.

  METHOD assert_load_fails.
    TRY.
        cl_xco_xlsx_file=>load( iv_content ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_xco_runtime_exception ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD zip.
    DATA lv_name TYPE string.

    DATA(lo_zip) = NEW cl_abap_zip( ).
    LOOP AT it_parts INTO DATA(lv_part).
      IF sy-tabix MOD 2 = 1.
        lv_name = lv_part.
      ELSE.
        lo_zip->add( name    = lv_name
                     content = cl_abap_conv_codepage=>create_out( )->convert( lv_part ) ).
      ENDIF.
    ENDLOOP.
    rv_content = lo_zip->save( ).
  ENDMETHOD.

  METHOD part_text.
    DATA lv_part TYPE xstring.

    DATA(lo_zip) = NEW cl_abap_zip( ).
    lo_zip->load( iv_content ).
    lo_zip->get( EXPORTING name    = iv_name
                 IMPORTING content = lv_part
                 EXCEPTIONS OTHERS = 1 ).
    cl_abap_unit_assert=>assert_subrc( ).
    rv_text = cl_abap_conv_codepage=>create_in( )->convert( lv_part ).
  ENDMETHOD.

  METHOD openpyxl_fixture.
    rv_content = cl_web_http_utility=>decode_x_base64(
      `UEsDBBQAAAAIANRcT11Gx01IlQAAAM0AAAAQAAAAZG9jUHJvcHMvYXBwLnhtbE3PTQvCMAwG4L9SdreZih6kDkQ9ip68zy51hbYpbYT67+0EP2`
      && `55ecgboi6JIia2mEXxLuRtMzLHDUDWI/o+y8qhiqHke64x3YGMsRoPpB8eA8OibdeAhTEMOMzit7Dp1C5GZ3XPlkJ3sjpRJsPiWDQ6sScfq9wc`
      && `ChDneiU+ixNLOZcrBf+LU8sVU57mym/8ZAW/B7oXUEsDBBQAAAAIANRcT13C6Jz17wAAACsCAAARAAAAZG9jUHJvcHMvY29yZS54bWzNklFLwz`
      && `AQx7+K5L29tNUxQtcXxScFwYHiW0huW1iThuSk3bc3jVuH6AfwMXf//O53cK3yQg0BX8LgMZDBeDPZ3kWh/IYdiLwAiOqAVsYyJVxq7oZgJaVn`
      && `2IOX6ij3CDXnK7BIUkuSMAMLvxBZ12olVEBJQzjjtVrw/jP0GaYVYI8WHUWoygpYN0/0p6lv4QqYYYTBxu8C6oWYq39icwfYOTlFs6TGcSzHJu`
      && `fSDhW8Pz+95nUL4yJJpzD9ikbQyeOGXSa/NfcP20fW1bxeFRUvqrstX4tmLW75x+z6w+8qbAdtduYfG18EuxZ+3UX3BVBLAwQUAAAACADUXE9d`
      && `mVycIxAGAACcJwAAEwAAAHhsL3RoZW1lL3RoZW1lMS54bWztWltz2jgUfu+v0Hhn9m0LxjaBtrQTc2l227SZhO1OH4URWI1seWSRhH+/RzYQy5`
      && `YN7ZJNups8BCzp+85FR+foOHnz7i5i6IaIlPJ4YNkv29a7ty/e4FcyJBFBMBmnr/DACqVMXrVaaQDDOH3JExLD3IKLCEt4FMvWXOBbGi8j1uq0`
      && `291WhGlsoRhHZGB9XixoQNBUUVpvXyC05R8z+BXLVI1lowETV0EmuYi08vlsxfza3j5lz+k6HTKBbjAbWCB/zm+n5E5aiOFUwsTAamc/VmvH0d`
      && `JIgILJfZQFukn2o9MVCDINOzqdWM52fPbE7Z+Mytp0NG0a4OPxeDi2y9KLcBwE4FG7nsKd9Gy/pEEJtKNp0GTY9tqukaaqjVNP0/d93+ubaJwK`
      && `jVtP02t33dOOicat0HgNvvFPh8Ouicar0HTraSYn/a5rpOkWaEJG4+t6EhW15UDTIABYcHbWzNIDll4p+nWUGtkdu91BXPBY7jmJEf7GxQTWad`
      && `IZljRGcp2QBQ4AN8TRTFB8r0G2iuDCktJckNbPKbVQGgiayIH1R4Ihxdyv/fWXu8mkM3qdfTrOa5R/aasBp+27m8+T/HPo5J+nk9dNQs5wvCwJ`
      && `8fsjW2GHJ247E3I6HGdCfM/29pGlJTLP7/kK6048Zx9WlrBdz8/knoxyI7vd9lh99k9HbiPXqcCzIteURiRFn8gtuuQROLVJDTITPwidhphqUB`
      && `wCpAkxlqGG+LTGrBHgE323vgjI342I96tvmj1XoVhJ2oT4EEYa4pxz5nPRbPsHpUbR9lW83KOXWBUBlxjfNKo1LMXWeJXA8a2cPB0TEs2UCwZB`
      && `hpckJhKpOX5NSBP+K6Xa/pzTQPCULyT6SpGPabMjp3QmzegzGsFGrxt1h2jSPHr+BfmcNQockRsdAmcbs0YhhGm78B6vJI6arcIRK0I+Yhk2Gn`
      && `K1FoG2camEYFoSxtF4TtK0EfxZrDWTPmDI7M2Rdc7WkQ4Rkl43Qj5izouQEb8ehjhKmu2icVgE/Z5ew0nB6ILLZv24fobVM2wsjvdH1BdK5A8m`
      && `pz/pMjQHo5pZCb2EVmqfqoc0PqgeMgoF8bkePuV6eAo3lsa8UK6CewH/0do3wqv4gsA5fy59z6XvufQ9odK3NyN9Z8HTi1veRm5bxPuuMdrXNC`
      && `4oY1dyzcjHVK+TKdg5n8Ds/Wg+nvHt+tkkhK+aWS0jFpBLgbNBJLj8i8rwKsQJ6GRbJQnLVNNlN4oSnkIbbulT9UqV1+WvuSi4PFvk6a+hdD4s`
      && `z/k8X+e0zQszQ7dyS+q2lL61JjhK9LHMcE4eyww7ZzySHbZ3oB01+/ZdduQjpTBTl0O4GkK+A226ndw6OJ6YkbkK01KQb8P56cV4GuI52QS5fZ`
      && `hXbefY0dH758FRsKPvPJYdx4jyoiHuoYaYz8NDh3l7X5hnlcZQNBRtbKwkLEa3YLjX8SwU4GRgLaAHg69RAvJSVWAxW8YDK5CifEyMRehw55dc`
      && `X+PRkuPbpmW1bq8pdxltIlI5wmmYE2eryt5lscFVHc9VW/Kwvmo9tBVOz/5ZrcifDBFOFgsSSGOUF6ZKovMZU77nK0nEVTi/RTO2EpcYvOPmx3`
      && `FOU7gSdrYPAjK5uzmpemUxZ6by3y0MCSxbiFkS4k1d7dXnm5yueiJ2+pd3wWDy/XDJRw/lO+df9F1Drn723eP6bpM7SEycecURAXRFAiOVHAYW`
      && `FzLkUO6SkAYTAc2UyUTwAoJkphyAmPoLvfIMuSkVzq0+OX9FLIOGTl7SJRIUirAMBSEXcuPv75Nqd4zX+iyBbYRUMmTVF8pDicE9M3JD2FQl86`
      && `7aJguF2+JUzbsaviZgS8N6bp0tJ//bXtQ9tBc9RvOjmeAes4dzm3q4wkWs/1jWHvky3zlw2zreA17mEyxDpH7BfYqKgBGrYr66r0/5JZw7tHvx`
      && `gSCb/NbbpPbd4Ax81KtapWQrET9LB3wfkgZjjFv0NF+PFGKtprGtxtoxDHmAWPMMoWY434dFmhoz1YusOY0Kb0HVQOU/29QNaPYNNByRBV4xmb`
      && `Y2o+ROCjzc/u8NsMLEjuHti78BUEsDBBQAAAAIANRcT13BzIdU4AEAAG8EAAAYAAAAeGwvd29ya3NoZWV0cy9zaGVldDEueG1sdVTbjpswEP0V`
      && `xEr71phAINvlIm0SVe1Dq2hXbZ8dGC5aX6jtJO3fdwwJJSk82TM+Z+Yca+zkLNW7rgGM85szoVO3NqZ9JkTnNXCqF7IFgSelVJwaDFVFdKuAFh`
      && `2JM+J7XkQ4bYSbJV1ur7JEHg1rBOyVo4+cU/VnA0yeU3fpXhOvTVUbmyBZ0tIK3sB8b/cKIzJUKRoOQjdSOArK1H1ZPu9Ci+8APxo469HesU4O`
      && `Ur7b4EuRup4VBAxyYytQXE6wBcZsIZTx61LTHVpa4nh/rf6p845eDlTDVrKfTWHq1H1ynQJKemTmVZ4/w8XPP4E7amiWKHl2lPWZJbnd2N6Ia4`
      && `S9nzejMN9gI5N9oxwSYlCAjUl+wW/m8C9cHoWZYGxnGd0VTDB2c4wNXicUjhS3JIKmBmf+4MyfqfL44PteLHAJPsY5LqsoLmwUxM7jw1MQreIp`
      && `4305O1anbOkHq0WYkNPYZw849IDbsx2e6W7chhKrMFqvB9SNhWCwEMxY2DMc8CmRwajDh/WdwGAk0LsTGPwvMEKT0wLDQWA4I5CWBpRT0XZqIM`
      && `JRF2/hh3dNyGhc7VP8SlXVCO0wKJHmLdbIV/1494GRbSf9II2RvNvW+COAsgA8L6U018C+ruGPyf4CUEsDBBQAAAAIANRcT13J9FMVZgEAAIkC`
      && `AAAYAAAAeGwvd29ya3NoZWV0cy9zaGVldDIueG1sbVJNT8MwDP0rUQ4cl7LxJdZWYkMIDkgTCDhnq9tGS5qSeCvw67HLWk1ihyj+eHn2s5N2Pm`
      && `xjDYDiy9kmZrJGbG+VipsanI4T30JDmdIHp5HcUKnYBtBF/8hZNU2SK+W0aWSe9rFVyFO/Q2saWAURd87p8L0A67tMnssh8GKqGjmg8rTVFbwC`
      && `vrWrQJ4aWQrjoInGNyJAmcm789vljPE94N1AF49swUrW3m/ZeSoymXBDYGGDzKDp2sMSrGUiauPzwCnHkvzw2B7YH3rtpGWtIyy9/TAF1pm8ka`
      && `KAUu8svvjuEQ56LscG7zXqPA2+E4F15umGDa5NOJ7WPr+YpmpPJTd0CDiipwN6Me3RpuFpvmKguKG2MP86szj/FmfatXMhf2SqkDg4949sNpDR`
      && `8E6TrSyt7xSDOhLCS3rWoTJNFBZKIkom15dShD/hfw76tl/y2iN615s1/RUIDKB86T0ODs99/H35L1BLAwQUAAAACADUXE9dyjOVF3QCAACPCg`
      && `AADQAAAHhsL3N0eWxlcy54bWzdVl1vmzAU/SuI944kbChMwMOQIk3apkrtw16d2CSW/MGMqZL9+vnalITWt1KnPY2o4voezrmfiFaDvQj2cGLM`
      && `Jmcp1FCnJ2v7z1k2HE5MkuGD7plySKeNJNYdzTEbesMIHYAkRbZZrYpMEq7SplKj3Ek7JAc9Klun69mVhNtX6pzFxzQJcq2mrE4v7rqT8o7SNG`
      && `uqbNJoqk6rpRQ4nCCRLHkiok5bIvjecGB1RHJxCe4NOA5aaJNYVwMDsvMMvwO8Dicob9KRXGnjY4cI/gYJcCHmBDZpcDRVT6xlRu3cwXO88xWU`
      && `TPbjpXcZHA25rDef0ivB31yQvTaUmUWdwdVUgnXWEQw/nuBudZ8BaK2WzqCcHLUiPodnxmQ42QMT4gFm+7NbaJ+7m1GsYBBqNl1CkxlkwgH0b9`
      && `WC9o3s5q9kk54/aftldNUof/41asvuDev42Z/P3Rx/oT7tz7/Uz6aKbtq2aNrsTWD56vQHbK+4SiT7kQvL1XQ6cUqZetU7J2/J3r1tC333PGUd`
      && `GYV9nME6vdrfGeWjLOen7qGs6amr/Q12ZF3Mm+9icUXZmdF2Oprj3puJM1zU6QLCS2TnrziCcQIWRwDD4mAZYJzAwuL8T/Vs0XoChuW2jSJblL`
      && `NFOYEVQ1r/w+LEOaW74pWWZZ4XBdbRto1m0GJ9Kwr4i6thuQEDiwOR3tdrfNr4hry9B9hM39oQrFJ8E7FK8V4DEu8bMMoyPm0sDjCwKWC7A/Hj`
      && `cWCn4pw8h6liuWFvMI6UJYbALsZ3tCiQ7hTwi88He0vyvCzjCGDxDPIcQ+BtxBEsA8gBQ/LcfwdffI+y5+9Udv0XtPkDUEsDBBQAAAAIANRcT1`
      && `2XirscwAAAABMCAAALAAAAX3JlbHMvLnJlbHOdkrluwzAMQH/F0J4wB9AhiDNl8RYE+QFWog/YEgWKRZ2/r9qlcZALGXk9PBLcHmlA7Tiktoup`
      && `GP0QUmla1bgBSLYlj2nOkUKu1CweNYfSQETbY0OwWiw+QC4ZZre9ZBanc6RXiFzXnaU92y9PQW+ArzpMcUJpSEszDvDN0n8y9/MMNUXlSiOVWx`
      && `p40+X+duBJ0aEiWBaaRcnToh2lfx3H9pDT6a9jIrR6W+j5cWhUCo7cYyWMcWK0/jWCyQ/sfgBQSwMEFAAAAAgA1FxPXVvsTJ1UAQAAwAIAAA8A`
      && `AAB4bC93b3JrYm9vay54bWy1kkFPwkAQhf9KsweOFoiSCJaLRCUxSsRwX9opnbC708wOoPx6p20aSUyMF0+782bz8s2bvTsR77dE++TDuxAzU4`
      && `nU0zSNeQXexiuqIWinJPZWtORdGmsGW8QKQLxLx8PhJPUWg5nf9V4rTi8LEsgFKajYCBuEU/zuN2VyxIhbdCifmWnvDkziMaDHMxSZGZokVnR6`
      && `IsYzBbFunTM5l5lR19gAC+Y/5HUD+W63sVXEbt+sgmRmMlTDEjlK+6L1t8p4BH3cVQehB3QCvLACj0yHGsOusdEp0osx2hz6swtxyn+JkcoSc1`
      && `hQfvAQpMuRwTWAIVZYR5ME6yEzCmCbcdR/WXSjiTJdBMVT1AYvi5bu/0jWkFMokoH19SwZOJl5YhjsZHaBN/4Fb9yG1ydWQIkBihe1jqrr9vIV`
      && `J83Rjjm+vhnd6pYOzt2r9hqeyRb9AvrPM/8CUEsDBBQAAAAIANRcT12N9yxatAAAAIkCAAAaAAAAeGwvX3JlbHMvd29ya2Jvb2sueG1sLnJlbH`
      && `PFkk0KgzAQRq8ScoCO2tJFUVfduC1eIOj4g9GEzJTq7Wt1oYEuupGuwjch73swiR+oFbdmoKa1JMZeD5TIhtneAKhosFd0MhaH+aYyrlc8R1eD`
      && `VUWnaoQoCK7g9gyZxnumyCeLvxBNVbUF3k3x7HHgL2B4GddRg8hS5MrVyImEUW9jguUITzNZiqxMpMvKUMK/hSJPKDpQiHjSSJvNmr3684H1PL`
      && `/FrX2J69DfyeXjAN7PS99QSwMEFAAAAAgA1FxPXW6nJLweAQAAVwQAABMAAABbQ29udGVudF9UeXBlc10ueG1sxZTPTsMwDMZfpcp1ajJ24IDW`
      && `XYAr7MALhNZdo+afYm90b4/bbpNAo2IqEpdGje3v5/iLsn47RsCsc9ZjIRqi+KAUlg04jTJE8BypQ3Ka+DftVNRlq3egVsvlvSqDJ/CUU68hNu`
      && `snqPXeUvbc8Taa4AuRwKLIHsfEnlUIHaM1pSaOq4OvvlHyE0Fy5ZCDjYm44AShrhL6yM+AU93rAVIyFWRbnehFO85SnVVIRwsopyWu9Bjq2pRQ`
      && `hXLvuERiTKArbADIWTmKLqbJxBOG8Xs3mz/ITAE5c5tCRHYswe24syV9dR5ZCBKZ6SNeiCw9+3zQu11B9Us2j/cjpHbwA9WwzJ/xV48v+jf2sf`
      && `rHPt5DaP/6qverdNr4M18N78nmE1BLAQIUAxQAAAAIANRcT11Gx01IlQAAAM0AAAAQAAAAAAAAAAAAAACAAQAAAABkb2NQcm9wcy9hcHAueG1s`
      && `UEsBAhQDFAAAAAgA1FxPXcLonPXvAAAAKwIAABEAAAAAAAAAAAAAAIABwwAAAGRvY1Byb3BzL2NvcmUueG1sUEsBAhQDFAAAAAgA1FxPXZlcnC`
      && `MQBgAAnCcAABMAAAAAAAAAAAAAAIAB4QEAAHhsL3RoZW1lL3RoZW1lMS54bWxQSwECFAMUAAAACADUXE9dwcyHVOABAABvBAAAGAAAAAAAAAAA`
      && `AAAAgIEiCAAAeGwvd29ya3NoZWV0cy9zaGVldDEueG1sUEsBAhQDFAAAAAgA1FxPXcn0UxVmAQAAiQIAABgAAAAAAAAAAAAAAICBOAoAAHhsL3`
      && `dvcmtzaGVldHMvc2hlZXQyLnhtbFBLAQIUAxQAAAAIANRcT13KM5UXdAIAAI8KAAANAAAAAAAAAAAAAACAAdQLAAB4bC9zdHlsZXMueG1sUEsB`
      && `AhQDFAAAAAgA1FxPXZeKuxzAAAAAEwIAAAsAAAAAAAAAAAAAAIABcw4AAF9yZWxzLy5yZWxzUEsBAhQDFAAAAAgA1FxPXVvsTJ1UAQAAwAIAAA`
      && `8AAAAAAAAAAAAAAIABXA8AAHhsL3dvcmtib29rLnhtbFBLAQIUAxQAAAAIANRcT12N9yxatAAAAIkCAAAaAAAAAAAAAAAAAACAAd0QAAB4bC9f`
      && `cmVscy93b3JrYm9vay54bWwucmVsc1BLAQIUAxQAAAAIANRcT11upyS8HgEAAFcEAAATAAAAAAAAAAAAAACAAckRAABbQ29udGVudF9UeXBlc1`
      && `0ueG1sUEsFBgAAAAAKAAoAhAIAABgTAAAAAA==` ).
  ENDMETHOD.

  METHOD libreoffice_fixture.
    rv_content = cl_web_http_utility=>decode_x_base64(
      `UEsDBBQACAgIANxET10AAAAAAAAAAAAAAAAaAAAAeGwvX3JlbHMvd29ya2Jvb2sueG1sLnJlbHO9kstqwzAQRff5CjH7WLb7oBTL2ZRCtm36AU`
      && `IeWya2JEbTR/6+alMaB4LpwnQl5kpz70Ez1eZjHMQbUuy9U1BkOQh0xje96xS87B7Xd7CpV9UTDprTk2j7EEXqcVGBZQ73UkZjcdQx8wFdumk9`
      && `jZpTSZ0M2ux1h7LM81tJUw+ozzzFtlFA26YAsTsE/Iu3b9ve4IM3ryM6vhAhOfViMtTUISv4Lo9ikSUzkJcZyiUZIh8GjCeIYz0Xf7Vk/Lunfb`
      && `SIfCL4lRLc1zH7F9f/DFPOwdwsOhirCZtnprTp0/lM5R+YVSXP9r/+BFBLBwiyzuVs6QAAADYDAABQSwMEFAAICAgA3ERPXQAAAAAAAAAAAAAA`
      && `AA8AAAB4bC93b3JrYm9vay54bWyNU9uO2jAQfe9XRH7gDZIAm3ILKxpAu1JvWra7z04yIS6OHdnDAq367504sKVqVfUhiefiM+fMTGa3x0p6L2`
      && `Cs0CpmYS9gHqhM50JtY/blcd0dMc8iVzmXWkHMTmDZ7fzN7KDNLtV659F9ZWNWItYT37dZCRW3PV2DokihTcWRTLP1bW2A57YEwEr6/SCI/IoL`
      && `xVqEifkfDF0UIoOlzvYVKGxBDEiOxN6WorZsPiuEhKdWkMfr+iOviHbCZcb8+Svtz8ZLebbb12vKjlnBpQUSWurDp/QrZEiKuJTMyzlCOA6Gl5`
      && `TfIDRSJpUhZ+N4EnCwv+KN6RDvtBHftEIuN5nRUsYMzf5cjYiiyP4W2TSNeuSpvTiPz0Ll+hAzGtHp6nxwx2eRY0kDjAaj4cV3B2JbYsxG4bjP`
      && `POTpQ9OomEUBXSuEseiKOBROSl6A6jUWCfKvFLmZXb6ecg1dcuQNUfLc51TXbQlS4EVYkUriayaCAuY+HzR413c3kGmVex1e1VOvI3FaaQOdLU`
      && `6vAPv/ABw6ghdW1L2MxikQDOUneq9IUdhINFB80DlBLIjeOf4667O9BImcNPeCIAgbXDjie4vue95Mqen8x3ZKkRpo99GtJvP2RsTs+9uoHyWj`
      && `qN/tL8JBNwxXN913g+FNd71ar2kQyTIZr3/QmjrUCT1Jy9+ioX/uAYrNiVblGLPVMQO5cJx8Smvfjpp/WbH5T1BLBwjK/zXeGwIAAL8DAABQSw`
      && `MEFAAICAgA3ERPXQAAAAAAAAAAAAAAABMAAAB4bC90aGVtZS90aGVtZTEueG1szVfBctsgEL33KxjuCZIsObIndg5JPT10pjNN+gEIIYkGIQ3Q`
      && `pP77IrAlFDmu0zqd+oBhebxdHuxiX9/8rDl4olKxRqxgeBlAQAVpcibKFfz2sLlIIVAaixzzRtAV3FIFb9YfrvFSV7SmwCwXaolXsNK6XSKkiD`
      && `Fjddm0VJi5opE11mYoS5RL/Gxoa46iIJijGjMBd+vlKeubomCE3jXkR02FdiSScqxN6KpirYJA4NrE+MUCwUMXIFzvQ/3IabdOdQbC5T2x8fsr`
      && `LDZ/DLsvJcvslkvwhPkKBvYD0foa9QCup7jCfna4HSB/jCa4sIgXV3nPFzm+KY5SSmjY81kAJsTsYuo7LtIw23N6INedcpMgCeIx3uOfTfCLLM`
      && `uSxQg/G/DxBJ8G8xhHI3w84JNp/JmZmY/wyYCfT7W+WszjMd6CKs7E48ET7E+mhxQN/3QQnhp4uj/wAYW8m+PWC/3aParx90ZuDMAerrmkAuht`
      && `SwtMDO4W15lkGIKWaVJtcM341gQJAamwVFSbK9I5x0uKvVXORNQLE3rhrGbimGfOjOvzeR6cIV8QK0/tDxjn93rL6WdlA1MNZ/nGGO3Awnr528`
      && `p0oWXsZ9zIX1RKPPTVjrZUoG1Ut6MjvKYiMKGdLfFSe+ysVD7hrAOeSjq7Oo00dIXlRNYwOcaKPBXMdQW4q+DhPHIugCKY07w/Xs04/UqJBtye`
      && `vrattG3Wtc7LSOK/kFtVOKc7vcPTpEl/r4zHupidT3CfNj6D4sGfKY6mOcPFeASeTYhJlJjsxa0piSbZTbdujVMlSggwL82jTrTbVyuVvsOqcl`
      && `uzqbR/WsTAFyVxF/z5CGdpeB5C9FIAWhRGz1csw9DMOZKDs+cHo0ORZeXmPy2A8YkFMH5LqYr3pWqcTot3ydLo6A78LG2xrkDXmDvHJOHuqe7S`
      && `7KHZ56Z7ELr8vHA1qEvSndEkaph63jqqf19NB5nTE8/ujYLO3knQ5ICeyRnkRNP8QqOfH2jyH2BvWf8CUEsHCDuh3wr0AgAAAg0AAFBLAwQUAA`
      && `gICADcRE9dAAAAAAAAAAAAAAAADQAAAHhsL3N0eWxlcy54bWztWE9vmzAcve9TWL63QJKm7QRUXadMu0zVmkqV1h1cMGDVf5DttKGffjYGAmm7`
      && `rdlhqUQuxo/fe3682IlxeLZmFDxgqYjgEQwOfQgwT0RKeB7B6+Xi4AQCpRFPERUcR7DCCp7FH0KlK4qvCow1MApcRbDQuvzoeSopMEPqUJSYmz`
      && `uZkAxp05W5p0qJUaosiVFv4vtzjyHCYRzyFVswrUAiVlxHcNpBwDVfU+NtPoPAyV2I1Fj5gjmWiELvxeKjtxTPh8WV+dweMHZ7kKaW4TX+4jAT`
      && `fGNzBh0Qh+oJPCBqlAJbnggqJNAmB6NVIxwx7CouECV3klgwQ4zQysGTmlcgqUygTqoe2MlvDeIPJc8lcQ/WF/T3hl43NjpCaRfdBDogDkukNZ`
      && `Z8YTqguV5WpQmOm/nmZOq6P1TnElXB5KhHqBsz7p2QqZnf7cgBbCGQEpQLjuh1GcEMUYVhB30Wj7wF45DiTBthSfLCtlqUnhXRWjBz0XLs0E65`
      && `uzDDJ5jSK7tYbrLN0/tGdJ09n9y87pg1aL03l06p6aCypNVCWBEtV7gBPtUlA+ickpwzvFV4KYXGia7Xeg3HIWoLQSEkeTLS9gvMm+Vifxo0SS`
      && `zknhcCjdf6u9DIqRhPjxKVSwN2IRKe1gObe6qQhN8vxYJ0t01MZWcDUJHc47Q1WZDUUHuV3jrbSsrf5BTsmlPjczuoPtxPqp0G78fMZDTzipmd`
      && `19ZoZjQzmhnNjGZ2MTOb7tM/5SzYKzezvXIz2Sc3p//ZjNffvrvNfG8fP911G7/Onjvv+/lH6+9tT9+8rY+xvTW2+RjbX8XmNQu39zreLeI57K`
      && `HAHmxE8Js9DKK95O5WhGrCXc97TrgQjKG2PjgaEKavEsAP/2dHmg9I8xdJKykxT6qOczzgzH7HGYx1MuAdv8S7xDIx30FHOR1Q3EHLJkzT2ZwI`
      && `xr8AUEsHCJm/uVXFAgAAVhQAAFBLAwQUAAgICADcRE9dAAAAAAAAAAAAAAAAGAAAAHhsL3dvcmtzaGVldHMvc2hlZXQxLnhtbL1WTW/bOBC976`
      && `8QdNo9xPqwZSeB7CK1620Bd13UyRbojRYpiwhFaknKTvLrd0h92gqKoIfcyOHwzZs3JIfxh6ecOUciFRV87gYj33UITwSm/DB3H+7XV9euozTi`
      && `GDHBydx9Jsr9sPgjPgn5qDJCtAMAXM3dTOvi1vNUkpEcqZEoCIeVVMgcaZjKg6cKSRC2m3Lmhb4/9XJEuVsh3Mq3YIg0pQlZiaTMCdcViCQMaa`
      && `CvMlqoBu0JvwkPS3SCVBs+PYqraqXFCyYDvJwmUiiR6lEi8praMMsb7+YszycZ/h5SEEGqR2oqFTZgefKWLHMkH8viCrALUGpPGdXPNmF3EVv8`
      && `b9JJKdNEfhUYipwipgisFehAdkQ/FHZd34tvYGiWvUXs1ZsXMaZQD8PMkSSdu3fB7SoyHtbhX0pOqjd2VCZOa+BXMqQaOGv8W1K8oZyAVcuyNn`
      && `4Xp6Vgn0ELOKb9hZ8ERGsMkh4yYLghqW4hNdrvCCOJJri/b1tqBkF2z/lesBYAkxSVTBsKEE7Ixn4ExnOXGzkZQIrChFgSxkyarpMY3y+AP524`
      && `zosQ+S5BDEQKfL83/8duv7QaOTfoWZRWlnrV3Ky9EI/GZHB9UySbhZG3QOYW1ixcB4H1SDo23bza6qj/6oJ09TLA/XFTmrU9MVDqWglQ4QfFOp`
      && `u716Pp7GZ6PYtalaAmn4lRHEiD9QUq0cxr7UUl8oYcCQNvS6ZvA/QqN+8seM1lhTRaxFKcHKiDUblUWuSVUxuiiZ5RjAlvzZXvL+hYLlA3hgpl`
      && `TkZz3BMTzKiorAdsVmA9LvzYOwLPpPb4OPQIzj2WQ4/w3GM19Bi3Hh7k3SYfvmvy4YDW5CL5vgevkg/Hk1F0oUDlFli3PbilcDRRG+3++8OnP/`
      && `+KvfQV8VbV1rAXYRJNZ7PX5Rm/qzzjgTwXeX8cD+S5ml1IM/6lNOu7za7T5uLorcZDbaYg/+vaRO+qTTTQZnqReDTQxh+F0QV3r3f/C0m53ha2`
      && `uTsZNABoyF3DOHTN4tICTat5vjMh6YvgGrEl/BiI7Iibb4+myXDBqzrfVyQPFAIz21L8kXn+ZCVONYFX2NZxLzQIZ4eZ7VLGIQqC6yDww/E0DP`
      && `3JzHVSIfTrS17bacsCHviCyB19gVf+BvTqNRPbgesXOain7SPsOgZiK210LE78PiN8CxlCCSWFBO0Xae4WQmqJKLSOPUPJ4x3HPzKq26buwIeo`
      && `10ATaCRLkZu/ljI9kJ8JuiooXEBDrVGysySioMQec8iuUmVtBXAwTVNQm+s1laoL1Zq3GH86dsdyEQuMq+YPh6M3hmGFWJnbcT8YTNuP6uJ/UE`
      && `sHCM9d5C3mAwAA7AoAAFBLAwQUAAgICADcRE9dAAAAAAAAAAAAAAAAGAAAAHhsL3dvcmtzaGVldHMvc2hlZXQyLnhtbL1WTW/bOBC9768QeK9l`
      && `KYnzAVlF69TbBdK6qNMW2BstUhYRisMlKTvJr++Q+kxSFMEeejBAzlBv3rzhDJ29va9ldODGClBLkszmJOKqACbUfkm+3a7fXJDIOqoYlaD4kj`
      && `xwS97mf2VHMHe24txFCKDsklTO6as4tkXFa2pnoLlCTwmmpg63Zh9bbThl4aNaxul8vohrKhRpEa7MazCgLEXBr6Foaq5cC2K4pA7p20po26Pd`
      && `s1fhMUOPmGrPZ0LxuvUMeMnpC7xaFAYslG5WQN1Re5nlZXz5JM97k/4/pOQMUz0IX6m0B6uL12RZU3PX6DeIrVGpnZDCPYSESZ4F/C8mKoV03H`
      && `wChkUuqbQcfZru+Za7bzr43S18QUPvjvMs7j7OMyawHp5ZZHi5JO+Sq9WJPxEOfBf8aCfryFZwXCO/RlLbwwXj30awG6E4Wp1pOuNXOK5AfkQt`
      && `8JpOHf9yFK03GLGvkOENL90A6ehuyyUvHGdPwmwaJzHK9qHegRwQGC9pI53ngPHA9PYDUl4S5fWUiAnax1hxKX2eJCr82X8wwOKURI8A9bagEl`
      && `VK5vPJ/nP4/LnV63lDH6AJunRe31o7gDtv8rhzX6WQhtdXU9+GHQsSUbQe+Mhm3LefRva/riJjwTzwdN3XZh2uDNa6UwJV+CGYq5bkYrY4v1xc`
      && `nJ8NKmFRPnIvOZJG6yOWot93QkMr8g0/cImnA5mpDdHb3OInwTsu19TRPDNwjLAOXuXGOqjbQ0OIPnolGONqMLdnf0MncMG6SarteDXyrPDBvI`
      && `o2nMCPFVoP+WmaxQckWuAPKQ280j/J63064WUDr/Nf0zr5k7Swz5/TOntGK55UVBuh3EaHeR1V2NM4Y8cZsB/7/7kF51DfkBUY8QjKUbnCR4Cb`
      && `SXfjS+ZE8dIRt8PsEzV7gYFlmBLzmb/Qps273WBfheu2A4eahGUVBo8/cJYkF0kyT08WaTo/PSdRCeB+7YqH4dlobFnNzVY8Yt9eoliT8RCGat`
      && `djSbcd2opEHmJjQnQGR3VbcbXBDLE6RmCC4dVbEg3GGSpwGOwkLe7eKfajEm6Y0xG+cZOZWOBoWEHtn0/rp5p6Iui1Fnh/PLVeydFSgBa+MmGS`
      && `tKqsgwARE2WJaiu3FsaOoQbzhrEPh/HG5Rkw1s5zvByTNS5bxNY8rKfBcDv898h/AlBLBwh4gegzeAMAAL8IAABQSwMEFAAICAgA3ERPXQAAAA`
      && `AAAAAAAAAAABQAAAB4bC9zaGFyZWRTdHJpbmdzLnhtbI2RTU7DMBCF95zC8iI76sAClcZxBUgsEQs4gJVME4v4p55J1LLkHFwACYkdF8hNOAku`
      && `XXSHvBo9zffek2bkemcHNkFE413NLxYlZ+Aa3xrX1fz56f58yRmSdq0evIOa7wH5Wp1JRGLJ6rDmPVFYCYFND1bjwgdwabPx0WpKMnYCQwTdYg`
      && `9AdhCXZXklrDaOs8aPjmp+zdnozHaEu6NeciXRKPlXscKgm9ScMhDiBFw9aAtSkJLiAP0D3thDXh7akJnyUm+9f4GWeZdFz+9u/mrm73b+YD9v`
      && `n1mexyFdJ4vUG4LIOh2y6F0xULVnhbahYsV29FS9HsfJLtJn1S9QSwcIJ0qteP0AAAAXAgAAUEsDBBQACAgIANxET10AAAAAAAAAAAAAAAALAA`
      && `AAX3JlbHMvLnJlbHOtksFOwzAMhu97iir3Nd1ACKGmu0xIuyE0HsAkbhu1iaPEg/L2RBMSDI2yw45xfn/+YqXeTG4s3jAmS16JVVmJAr0mY32n`
      && `xMv+cXkvNs2ifsYROEdSb0Mqco9PSvTM4UHKpHt0kEoK6PNNS9EB52PsZAA9QIdyXVV3Mv5kiOaEWeyMEnFnVqLYfwS8hE1tazVuSR8cej4z4l`
      && `cikyF2yEpMo3ynOLwSDWWGCnneZX25y9/vlA4ZDDBITRGXIebuyBbTt44h/ZTL6ZiYE7q55nJwYvQGzbwShDBndHtNI31ITO6fFR0zX0qLWp78`
      && `y+YTUEsHCIWaNJruAAAAzgIAAFBLAwQUAAgICADcRE9dAAAAAAAAAAAAAAAAEQAAAGRvY1Byb3BzL2NvcmUueG1snVLLTsMwELzzFZHviZMWqi`
      && `pKXAlQT1RCahGIm3G2qcFxLNttmr/HThvz6onb7sx49uVicWxEdABteCtLlCUpikCytuKyLtHTZhnPUWQslRUVrYQS9WDQglwVTOWs1fCoWwXa`
      && `cjCRM5ImZ6pEO2tVjrFhO2ioSZxCOnLb6oZal+oaK8o+aA14kqYz3IClFbUUe8NYBUd0tqxYsFR7LQaDimEQ0IC0BmdJhr+0FnRjLj4YmG/Kht`
      && `tewUXpSAb10fAg7Lou6aaD1PWf4ZfVw3oYNebSr4oBIsW5kZxpoBaqyBnkp3Ij8zy9u98sEZmkk1mcpXF2s0nn+XSeX6evBf713hue4lYTv1DV`
      && `H4VXBdALKjBMc2XdLclA/gBcLqis927xBGT8tB4kAfInFdTYlTv+lkN12zuPC9jYWXPG/j3aaDBU1nDg/g+SdCgaUt+12b+9A7OnkULiYsutgB`
      && `M8hn/+JfkEUEsHCJjqxIpiAQAA4wIAAFBLAwQUAAgICADcRE9dAAAAAAAAAAAAAAAAEAAAAGRvY1Byb3BzL2FwcC54bWydkMFuwjAMhu97iiri`
      && `2iZEHUMoDdo07YS0HTq0W5UlLmRqk6hxUXn7BdCA83yyf1uf7V+sp77LDjBE611F5gUjGTjtjXW7inzWb/mSZBGVM6rzDipyhEjW8kF8DD7AgB`
      && `ZilgguVmSPGFaURr2HXsUitV3qtH7oFaZy2FHftlbDq9djDw4pZ2xBYUJwBkwerkByIa4O+F+o8fp0X9zWx5B4UtTQh04hSEFvae1RdbXtQbIk`
      && `XwvxHEJntcLkiNzY7wHezysoLwtePBV8trFunJqv5aJZlNndRJN++AGNtORs9jLazuRc0Hvcib29mC3njwVLcR740wS9+Sp/AVBLBwhelgGP+w`
      && `AAAJwBAABQSwMEFAAICAgA3ERPXQAAAAAAAAAAAAAAABMAAABkb2NQcm9wcy9jdXN0b20ueG1snc6xCsIwFIXh3acI2dtUB5HStIs4O1T3kN62`
      && `AXNvyE2LfXsjgu6Ohx8+TtM9/UOsENkRarkvKykALQ0OJy1v/aU4ScHJ4GAehKDlBiy7dtdcIwWIyQGLLCBrOacUaqXYzuANlzljLiNFb1KecV`
      && `I0js7CmeziAZM6VNVR2YUT+SJ8Ofnx6jX9Sw5k3+/43m8he22jfmfbF1BLBwjh1gCAlwAAAPEAAABQSwMEFAAICAgA3ERPXQAAAAAAAAAAAAAA`
      && `ABMAAABbQ29udGVudF9UeXBlc10ueG1sxVVLT8MwDL7vV1S9ojbbDgihbjvwOMIkxhmFxG3D2iSKs7H9e9wWpjH2oOoEl0aN/T3sJm4yWZVFsA`
      && `SHyuhROIj7YQBaGKl0NgqfZ/fRVTgZ95LZ2gIGlKtxFObe22vGUORQcoyNBU2R1LiSe3p1GbNczHkGbNjvXzJhtAftI19xhOPkFlK+KHxwt6Lt`
      && `RpfgYXDT5FVSo5BbWyjBPYVZFWV7cQ4KPAJcarnjLvp0FhOyzsFcWbw4rGB1tiOgyqqyan8/4s3CfkgdIMwjtdspCcGUO//AS0pgq4K9VMWwd+`
      && `Pmr8bMY7IUn7m8A8Lbku3UTJoqAdKIRUmQGK0DLjEH8GS+XuOSK31C39MxguY56OyhpjkhiH5dAJ673Jr0F62uAcjqpXu9301s+Fv6GP6TD8y5`
      && `A/nkHY2bs3+Qbe5jPpqL9xeXjZxOnbFII9FB+3K/9Cp0ZIkInFfHz9xGkag79xeqISdBttUWC/Sm7Czf0PwU7yWs/j2NPwBQSwcIuJCdonkBAA`
      && `DNBgAAUEsBAhQAFAAICAgA3ERPXbLO5WzpAAAANgMAABoAAAAAAAAAAAAAAAAAAAAAAHhsL19yZWxzL3dvcmtib29rLnhtbC5yZWxzUEsBAhQA`
      && `FAAICAgA3ERPXcr/Nd4bAgAAvwMAAA8AAAAAAAAAAAAAAAAAMQEAAHhsL3dvcmtib29rLnhtbFBLAQIUABQACAgIANxET107od8K9AIAAAINAA`
      && `ATAAAAAAAAAAAAAAAAAIkDAAB4bC90aGVtZS90aGVtZTEueG1sUEsBAhQAFAAICAgA3ERPXZm/uVXFAgAAVhQAAA0AAAAAAAAAAAAAAAAAvgYA`
      && `AHhsL3N0eWxlcy54bWxQSwECFAAUAAgICADcRE9dz13kLeYDAADsCgAAGAAAAAAAAAAAAAAAAAC+CQAAeGwvd29ya3NoZWV0cy9zaGVldDEueG`
      && `1sUEsBAhQAFAAICAgA3ERPXXiB6DN4AwAAvwgAABgAAAAAAAAAAAAAAAAA6g0AAHhsL3dvcmtzaGVldHMvc2hlZXQyLnhtbFBLAQIUABQACAgI`
      && `ANxET10nSq14/QAAABcCAAAUAAAAAAAAAAAAAAAAAKgRAAB4bC9zaGFyZWRTdHJpbmdzLnhtbFBLAQIUABQACAgIANxET12FmjSa7gAAAM4CAA`
      && `ALAAAAAAAAAAAAAAAAAOcSAABfcmVscy8ucmVsc1BLAQIUABQACAgIANxET12Y6sSKYgEAAOMCAAARAAAAAAAAAAAAAAAAAA4UAABkb2NQcm9w`
      && `cy9jb3JlLnhtbFBLAQIUABQACAgIANxET11elgGP+wAAAJwBAAAQAAAAAAAAAAAAAAAAAK8VAABkb2NQcm9wcy9hcHAueG1sUEsBAhQAFAAICA`
      && `gA3ERPXeHWAICXAAAA8QAAABMAAAAAAAAAAAAAAAAA6BYAAGRvY1Byb3BzL2N1c3RvbS54bWxQSwECFAAUAAgICADcRE9duJCdonkBAADNBgAA`
      && `EwAAAAAAAAAAAAAAAADAFwAAW0NvbnRlbnRfVHlwZXNdLnhtbFBLBQYAAAAADAAMAAcDAAB6GQAAAAA=` ).
  ENDMETHOD.
ENDCLASS.
