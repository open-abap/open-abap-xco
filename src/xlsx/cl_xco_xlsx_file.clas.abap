" content of an .xlsx file: the worksheets and their cell values, read from and
" written to Office Open XML, ECMA-376 Part 1, SpreadsheetML
CLASS cl_xco_xlsx_file DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    TYPES ty_type TYPE c LENGTH 1.

    TYPES:
      BEGIN OF ty_cell,
        sheet  TYPE i,
        row    TYPE i,
        column TYPE i,
        " gc_type, initial for a cell without value
        type   TYPE ty_type,
        " the value as stored in the file, shared strings resolved
        value  TYPE string,
        " gc_style, used when writing
        style  TYPE i,
      END OF ty_cell.
    TYPES ty_cells TYPE SORTED TABLE OF ty_cell WITH UNIQUE KEY sheet row column.

    CONSTANTS:
      BEGIN OF gc_type,
        number  TYPE ty_type VALUE 'n',
        string  TYPE ty_type VALUE 's',
        boolean TYPE ty_type VALUE 'b',
        error   TYPE ty_type VALUE 'e',
      END OF gc_type.

    CONSTANTS:
      BEGIN OF gc_style,
        none TYPE i VALUE 0,
        date TYPE i VALUE 1,
        time TYPE i VALUE 2,
      END OF gc_style.

    " the size of a worksheet in Excel, XFD1048576 is the last cell
    CONSTANTS gc_max_row TYPE i VALUE 1048576.
    CONSTANTS gc_max_column TYPE i VALUE 16384.

    DATA mt_cells TYPE ty_cells READ-ONLY.

    " one worksheet named Sheet1
    CLASS-METHODS empty
      RETURNING
        VALUE(ro_file) TYPE REF TO cl_xco_xlsx_file.

    " raises cx_xco_runtime_exception if the content is not an .xlsx file
    CLASS-METHODS load
      IMPORTING
        iv_content     TYPE xstring
      RETURNING
        VALUE(ro_file) TYPE REF TO cl_xco_xlsx_file.

    METHODS save
      RETURNING
        VALUE(rv_content) TYPE xstring.

    METHODS get_sheet_count
      RETURNING
        VALUE(rv_count) TYPE i.

    " ignoring case, as Excel does; 0 if there is no worksheet with this name
    METHODS get_sheet_position
      IMPORTING
        iv_name            TYPE string
      RETURNING
        VALUE(rv_position) TYPE i.

    " the last row with a value in the given columns, 0 if there is none
    METHODS get_last_row
      IMPORTING
        iv_sheet       TYPE i
        iv_from_column TYPE i
        iv_to_column   TYPE i
      RETURNING
        VALUE(rv_row)  TYPE i.

    " without name, the first free name of Sheet1, Sheet2, ... is used
    METHODS add_sheet
      IMPORTING
        iv_name TYPE string OPTIONAL.

    METHODS set_sheet_name
      IMPORTING
        iv_position TYPE i
        iv_name     TYPE string.

    " a cell without type is removed; raises cx_xco_runtime_exception outside of the worksheet
    METHODS set_cell
      IMPORTING
        is_cell TYPE ty_cell.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_relationship,
        id     TYPE string,
        type   TYPE string,
        target TYPE string,
      END OF ty_relationship.
    TYPES ty_relationships TYPE STANDARD TABLE OF ty_relationship WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_shared_string,
        value TYPE string,
        index TYPE i,
      END OF ty_shared_string.
    TYPES ty_shared_strings TYPE HASHED TABLE OF ty_shared_string WITH UNIQUE KEY value.
    TYPES ty_shared_string_list TYPE STANDARD TABLE OF ty_shared_string WITH EMPTY KEY.

    CONSTANTS gc_xml_header TYPE string VALUE `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>`.
    CONSTANTS gc_main TYPE string VALUE `http://schemas.openxmlformats.org/spreadsheetml/2006/main`.
    CONSTANTS gc_relationships TYPE string VALUE `http://schemas.openxmlformats.org/officeDocument/2006/relationships`.
    CONSTANTS gc_package TYPE string VALUE `http://schemas.openxmlformats.org/package/2006`.
    CONSTANTS gc_content_type TYPE string VALUE `application/vnd.openxmlformats-officedocument.spreadsheetml.`.

    DATA mt_sheet_names TYPE string_table.

    METHODS check_sheet_name
      IMPORTING
        iv_position TYPE i
        iv_name     TYPE string.

    METHODS read_workbook
      IMPORTING
        io_zip  TYPE REF TO cl_abap_zip
        iv_path TYPE string.

    METHODS read_worksheet
      IMPORTING
        io_zip            TYPE REF TO cl_abap_zip
        iv_sheet          TYPE i
        iv_path           TYPE string
        it_shared_strings TYPE string_table.

    " the cell type from the attribute t of <c>
    METHODS add_cell
      IMPORTING
        is_cell           TYPE ty_cell
        iv_xlsx_type      TYPE string
        iv_has_value      TYPE abap_bool
        it_shared_strings TYPE string_table.

    METHODS workbook_xml
      RETURNING
        VALUE(rv_xml) TYPE string.

    METHODS worksheet_xml
      IMPORTING
        iv_sheet          TYPE i
        it_shared_strings TYPE ty_shared_strings
      RETURNING
        VALUE(rv_xml)     TYPE string.

    CLASS-METHODS check_position
      IMPORTING
        iv_row    TYPE i
        iv_column TYPE i.

    CLASS-METHODS read_part
      IMPORTING
        io_zip         TYPE REF TO cl_abap_zip
        iv_path        TYPE string
      RETURNING
        VALUE(rv_part) TYPE xstring.

    CLASS-METHODS read_relationships
      IMPORTING
        io_zip                  TYPE REF TO cl_abap_zip
        iv_part                 TYPE string
      RETURNING
        VALUE(rt_relationships) TYPE ty_relationships.

    CLASS-METHODS read_shared_strings
      IMPORTING
        io_zip            TYPE REF TO cl_abap_zip
        iv_path           TYPE string
      RETURNING
        VALUE(rt_strings) TYPE string_table.

    CLASS-METHODS write_part
      IMPORTING
        io_zip  TYPE REF TO cl_abap_zip
        iv_path TYPE string
        iv_xml  TYPE string.

    CLASS-METHODS styles_xml
      RETURNING
        VALUE(rv_xml) TYPE string.

    CLASS-METHODS shared_strings_xml
      IMPORTING
        it_shared_strings TYPE ty_shared_strings
      RETURNING
        VALUE(rv_xml)     TYPE string.

    CLASS-METHODS resolve
      IMPORTING
        iv_part        TYPE string
        iv_target      TYPE string
      RETURNING
        VALUE(rv_path) TYPE string.

    CLASS-METHODS xml_escape
      IMPORTING
        iv_text        TYPE string
      RETURNING
        VALUE(rv_text) TYPE string.

    " Excel writes characters XML 1.0 cannot hold, and carriage returns, as _xHHHH_,
    " and a text that looks like such an escape with its underscore as _x005F_
    CLASS-METHODS excel_escape
      IMPORTING
        iv_text        TYPE string
      RETURNING
        VALUE(rv_text) TYPE string.

    CLASS-METHODS excel_unescape
      IMPORTING
        iv_text        TYPE string
      RETURNING
        VALUE(rv_text) TYPE string.
ENDCLASS.

CLASS cl_xco_xlsx_file IMPLEMENTATION.
  METHOD empty.
    ro_file = NEW cl_xco_xlsx_file( ).
    ro_file->add_sheet( ).
  ENDMETHOD.

  METHOD load.
    DATA(lo_zip) = NEW cl_abap_zip( ).
    TRY.
        lo_zip->load( iv_content ).
      CATCH cx_sy_compression_error cx_sy_range_out_of_bounds cx_sy_conversion_error cx_sy_buffer_overflow
          INTO DATA(lx_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_error ).
    ENDTRY.

    DATA(lv_workbook) = `xl/workbook.xml`.
    DATA(lt_relationships) = read_relationships( io_zip  = lo_zip
                                                 iv_part = `` ).
    LOOP AT lt_relationships INTO DATA(ls_relationship).
      IF ls_relationship-type CP '*/officeDocument'.
        lv_workbook = ls_relationship-target.
      ENDIF.
    ENDLOOP.

    ro_file = NEW cl_xco_xlsx_file( ).
    ro_file->read_workbook( io_zip  = lo_zip
                            iv_path = lv_workbook ).
  ENDMETHOD.

  METHOD read_part.
    TRY.
        io_zip->get(
          EXPORTING
            name                    = iv_path
          IMPORTING
            content                 = rv_part
          EXCEPTIONS
            zip_index_error         = 1
            zip_decompression_error = 2
            OTHERS                  = 3 ).
      CATCH cx_sy_compression_error cx_sy_range_out_of_bounds cx_sy_conversion_error cx_sy_buffer_overflow
          INTO DATA(lx_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_error ).
    ENDTRY.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
  ENDMETHOD.

  METHOD read_relationships.
    " the relationships of a part are stored in _rels/<name>.rels next to it
    DATA(lv_folder) = substring_before( val = iv_part
                                        sub = `/`
                                        occ = -1 ).
    DATA(lv_name) = substring_after( val = iv_part
                                     sub = `/`
                                     occ = -1 ).
    IF lv_folder IS INITIAL.
      lv_name = iv_part.
    ELSE.
      lv_folder = lv_folder && `/`.
    ENDIF.

    READ TABLE io_zip->files WITH KEY name = |{ lv_folder }_rels/{ lv_name }.rels| TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    DATA(lo_reader) = NEW lcl_xml_reader( read_part( io_zip  = io_zip
                                                     iv_path = |{ lv_folder }_rels/{ lv_name }.rels| ) ).
    WHILE lo_reader->next( ) = abap_true.
      IF lo_reader->mv_node_type = if_sxml_node=>co_nt_element_open
          AND lo_reader->mv_name = `Relationship`
          AND lo_reader->attribute( `TargetMode` ) <> `External`.
        APPEND VALUE #( id     = lo_reader->attribute( `Id` )
                        type   = lo_reader->attribute( `Type` )
                        target = resolve( iv_part   = iv_part
                                          iv_target = lo_reader->attribute( `Target` ) ) ) TO rt_relationships.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD read_workbook.
    " the worksheets in the order of the workbook, each with the id of its relationship
    DATA lt_shared_strings TYPE string_table.
    DATA lt_ids TYPE string_table.

    DATA(lo_reader) = NEW lcl_xml_reader( read_part( io_zip  = io_zip
                                                     iv_path = iv_path ) ).
    WHILE lo_reader->next( ) = abap_true.
      IF lo_reader->mv_node_type = if_sxml_node=>co_nt_element_open AND lo_reader->mv_name = `sheet`.
        APPEND lo_reader->attribute( `name` ) TO mt_sheet_names.
        APPEND lo_reader->attribute( `id` ) TO lt_ids.
      ENDIF.
    ENDWHILE.

    DATA(lt_relationships) = read_relationships( io_zip  = io_zip
                                                 iv_part = iv_path ).
    LOOP AT lt_relationships INTO DATA(ls_relationship).
      IF ls_relationship-type CP '*/sharedStrings'.
        lt_shared_strings = read_shared_strings( io_zip  = io_zip
                                                 iv_path = ls_relationship-target ).
      ENDIF.
    ENDLOOP.

    LOOP AT lt_ids INTO DATA(lv_id).
      DATA(lv_sheet) = sy-tabix.
      READ TABLE lt_relationships WITH KEY id = lv_id INTO ls_relationship.
      IF sy-subrc <> 0.
        RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
      ENDIF.
      read_worksheet( io_zip            = io_zip
                      iv_sheet          = lv_sheet
                      iv_path           = ls_relationship-target
                      it_shared_strings = lt_shared_strings ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read_shared_strings.
    " <si> holds one <t> or rich text runs <r><t>, phonetic hints <rPh> are no part of the value
    DATA lv_string TYPE string.
    DATA lv_in_text TYPE abap_bool.

    DATA(lo_reader) = NEW lcl_xml_reader( read_part( io_zip  = io_zip
                                                     iv_path = iv_path ) ).
    WHILE lo_reader->next( ) = abap_true.
      CASE lo_reader->mv_node_type.
        WHEN if_sxml_node=>co_nt_element_open.
          CASE lo_reader->mv_name.
            WHEN `si`.
              CLEAR lv_string.
            WHEN `t`.
              lv_in_text = abap_true.
            WHEN `rPh`.
              lo_reader->skip_element( ).
          ENDCASE.
        WHEN if_sxml_node=>co_nt_value.
          IF lv_in_text = abap_true.
            lv_string = lv_string && lo_reader->mv_value.
          ENDIF.
        WHEN if_sxml_node=>co_nt_element_close.
          CASE lo_reader->mv_name.
            WHEN `t`.
              lv_in_text = abap_false.
            WHEN `si`.
              APPEND excel_unescape( lv_string ) TO rt_strings.
          ENDCASE.
      ENDCASE.
    ENDWHILE.
  ENDMETHOD.

  METHOD read_worksheet.
    " r of <row> and <c> is optional, without it the position follows the previous one
    DATA ls_cell TYPE ty_cell.
    DATA lv_xlsx_type TYPE string.
    DATA lv_in_value TYPE abap_bool.
    DATA lv_has_value TYPE abap_bool.
    DATA lv_row TYPE string.
    DATA lv_reference TYPE string.
    DATA lv_letters TYPE string.

    ls_cell-sheet = iv_sheet.

    DATA(lo_reader) = NEW lcl_xml_reader( read_part( io_zip  = io_zip
                                                     iv_path = iv_path ) ).
    WHILE lo_reader->next( ) = abap_true.
      CASE lo_reader->mv_node_type.
        WHEN if_sxml_node=>co_nt_element_open.
          CASE lo_reader->mv_name.
            WHEN `row`.
              lv_row = lo_reader->attribute( `r` ).
              IF lv_row IS INITIAL.
                ls_cell-row = ls_cell-row + 1.
              ELSEIF matches( val   = lv_row
                              regex = `\d{1,7}` ).
                ls_cell-row = lv_row.
              ELSE.
                RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
              ENDIF.
              ls_cell-column = 0.
            WHEN `c`.
              lv_reference = lo_reader->attribute( `r` ).
              IF lv_reference IS INITIAL.
                ls_cell-column = ls_cell-column + 1.
              ELSE.
                FIND REGEX `^([A-Za-z]{1,3})(\d{1,7})$` IN lv_reference SUBMATCHES lv_letters lv_row.
                IF sy-subrc <> 0.
                  RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
                ENDIF.
                ls_cell-column = xco_cp_xlsx=>coordinate->for_alphabetic_value( lv_letters )->get_numeric_value( ).
                ls_cell-row = lv_row.
              ENDIF.
              lv_xlsx_type = lo_reader->attribute( `t` ).
              CLEAR: ls_cell-value, lv_has_value.
            WHEN `v` OR `t`.
              lv_in_value = abap_true.
              lv_has_value = abap_true.
            WHEN `f` OR `rPh` OR `extLst`.
              lo_reader->skip_element( ).
          ENDCASE.
        WHEN if_sxml_node=>co_nt_value.
          IF lv_in_value = abap_true.
            ls_cell-value = ls_cell-value && lo_reader->mv_value.
          ENDIF.
        WHEN if_sxml_node=>co_nt_element_close.
          CASE lo_reader->mv_name.
            WHEN `v` OR `t`.
              lv_in_value = abap_false.
            WHEN `c`.
              add_cell( is_cell           = ls_cell
                        iv_xlsx_type      = lv_xlsx_type
                        iv_has_value      = lv_has_value
                        it_shared_strings = it_shared_strings ).
          ENDCASE.
      ENDCASE.
    ENDWHILE.
  ENDMETHOD.

  METHOD add_cell.
    DATA(ls_cell) = is_cell.

    check_position( iv_row    = ls_cell-row
                    iv_column = ls_cell-column ).

    IF iv_has_value = abap_true.
      CASE iv_xlsx_type.
        WHEN `s`.
          IF NOT matches( val   = ls_cell-value
                          regex = `\d{1,9}` ).
            RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
          ENDIF.
          READ TABLE it_shared_strings INDEX ls_cell-value + 1 INTO ls_cell-value.
          IF sy-subrc <> 0.
            RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
          ENDIF.
          ls_cell-type = gc_type-string.
        WHEN `inlineStr` OR `str`.
          ls_cell-value = excel_unescape( ls_cell-value ).
          ls_cell-type = gc_type-string.
        WHEN `d`.
          ls_cell-type = gc_type-string.
        WHEN `b`.
          ls_cell-type = gc_type-boolean.
        WHEN `e`.
          ls_cell-type = gc_type-error.
        WHEN OTHERS.
          ls_cell-type = gc_type-number.
      ENDCASE.
    ENDIF.

    INSERT ls_cell INTO TABLE mt_cells.
  ENDMETHOD.

  METHOD check_position.
    IF iv_row < 1 OR iv_row > gc_max_row OR iv_column < 1 OR iv_column > gc_max_column.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
  ENDMETHOD.

  METHOD resolve.
    IF iv_target CP '/*'.
      rv_path = substring( val = iv_target
                           off = 1 ).
    ELSEIF iv_part CS `/`.
      rv_path = substring_before( val = iv_part
                                  sub = `/`
                                  occ = -1 ) && `/` && iv_target.
    ELSE.
      rv_path = iv_target.
    ENDIF.

    WHILE rv_path CS `/../`.
      REPLACE FIRST OCCURRENCE OF REGEX `[^/]+/\.\./` IN rv_path WITH ``.
      IF sy-subrc <> 0.
        RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

  METHOD get_sheet_count.
    rv_count = lines( mt_sheet_names ).
  ENDMETHOD.

  METHOD get_sheet_position.
    LOOP AT mt_sheet_names INTO DATA(lv_name).
      IF to_upper( lv_name ) = to_upper( iv_name ).
        rv_position = sy-tabix.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_last_row.
    LOOP AT mt_cells INTO DATA(ls_cell) WHERE sheet = iv_sheet AND type IS NOT INITIAL
        AND column >= iv_from_column AND column <= iv_to_column.
      IF ls_cell-row > rv_row.
        rv_row = ls_cell-row.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD add_sheet.
    DATA(lv_name) = iv_name.
    IF lv_name IS INITIAL.
      DATA(lv_number) = 1.
      WHILE get_sheet_position( |Sheet{ lv_number }| ) > 0.
        lv_number = lv_number + 1.
      ENDWHILE.
      lv_name = |Sheet{ lv_number }|.
    ENDIF.

    check_sheet_name( iv_position = lines( mt_sheet_names ) + 1
                      iv_name     = lv_name ).
    APPEND lv_name TO mt_sheet_names.
  ENDMETHOD.

  METHOD set_sheet_name.
    check_sheet_name( iv_position = iv_position
                      iv_name     = iv_name ).
    READ TABLE mt_sheet_names INDEX iv_position ASSIGNING FIELD-SYMBOL(<lv_name>).
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    <lv_name> = iv_name.
  ENDMETHOD.

  METHOD check_sheet_name.
    " the rules of Excel: 1 to 31 characters, none of []:*?/\ and no control characters,
    " no apostrophe at the start or the end, not History, unique ignoring case
    IF NOT matches( val  = iv_name
                    pcre = `[^\[\]:*?/\\\x00-\x1F]{1,31}` )
        OR matches( val  = iv_name
                    pcre = `'.*|.*'` )
        OR to_upper( iv_name ) = `HISTORY`.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    DATA(lv_position) = get_sheet_position( iv_name ).
    IF lv_position > 0 AND lv_position <> iv_position.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
  ENDMETHOD.

  METHOD set_cell.
    check_position( iv_row    = is_cell-row
                    iv_column = is_cell-column ).

    READ TABLE mt_cells WITH TABLE KEY sheet  = is_cell-sheet
                                       row    = is_cell-row
                                       column = is_cell-column TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      DELETE mt_cells INDEX sy-tabix.
    ENDIF.
    IF is_cell-type IS NOT INITIAL.
      INSERT is_cell INTO TABLE mt_cells.
    ENDIF.
  ENDMETHOD.

  METHOD save.
    DATA lt_shared_strings TYPE ty_shared_strings.
    DATA lt_parts TYPE string_table.
    DATA lt_overrides TYPE string_table.
    DATA lt_relationships TYPE string_table.

    LOOP AT mt_cells INTO DATA(ls_cell) WHERE type = gc_type-string.
      INSERT VALUE #( value = ls_cell-value
                      index = lines( lt_shared_strings ) ) INTO TABLE lt_shared_strings.
    ENDLOOP.

    DATA(lo_zip) = NEW cl_abap_zip( ).

    DO lines( mt_sheet_names ) TIMES.
      DATA(lv_sheet) = sy-index.
      write_part( io_zip  = lo_zip
                  iv_path = |xl/worksheets/sheet{ lv_sheet }.xml|
                  iv_xml  = worksheet_xml( iv_sheet          = lv_sheet
                                           it_shared_strings = lt_shared_strings ) ).
      APPEND |<Override PartName="/xl/worksheets/sheet{ lv_sheet }.xml" ContentType="{ gc_content_type }worksheet+xml"/>|
        TO lt_overrides.
      APPEND |<Relationship Id="rId{ lv_sheet }" Type="{ gc_relationships }/worksheet" Target="worksheets/sheet{ lv_sheet }.xml"/>|
        TO lt_relationships.
    ENDDO.

    write_part( io_zip  = lo_zip
                iv_path = `xl/sharedStrings.xml`
                iv_xml  = shared_strings_xml( lt_shared_strings ) ).
    write_part( io_zip  = lo_zip
                iv_path = `xl/styles.xml`
                iv_xml  = styles_xml( ) ).
    write_part( io_zip  = lo_zip
                iv_path = `xl/workbook.xml`
                iv_xml  = workbook_xml( ) ).

    APPEND |<Relationship Id="rId{ lines( mt_sheet_names ) + 1 }" Type="{ gc_relationships }/styles" Target="styles.xml"/>|
      TO lt_relationships.
    APPEND |<Relationship Id="rId{ lines( mt_sheet_names ) + 2 }" Type="{ gc_relationships }/sharedStrings" Target="sharedStrings.xml"/>|
      TO lt_relationships.
    write_part( io_zip  = lo_zip
                iv_path = `xl/_rels/workbook.xml.rels`
                iv_xml  = |<Relationships xmlns="{ gc_package }/relationships">{ concat_lines_of( lt_relationships ) }</Relationships>| ).

    write_part( io_zip  = lo_zip
                iv_path = `_rels/.rels`
                iv_xml  = |<Relationships xmlns="{ gc_package }/relationships">|
                       && |<Relationship Id="rId1" Type="{ gc_relationships }/officeDocument" Target="xl/workbook.xml"/>|
                       && `</Relationships>` ).

    APPEND |<Types xmlns="{ gc_package }/content-types">| TO lt_parts.
    APPEND `<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>` TO lt_parts.
    APPEND `<Default Extension="xml" ContentType="application/xml"/>` TO lt_parts.
    APPEND |<Override PartName="/xl/workbook.xml" ContentType="{ gc_content_type }sheet.main+xml"/>| TO lt_parts.
    APPEND LINES OF lt_overrides TO lt_parts.
    APPEND |<Override PartName="/xl/styles.xml" ContentType="{ gc_content_type }styles+xml"/>| TO lt_parts.
    APPEND |<Override PartName="/xl/sharedStrings.xml" ContentType="{ gc_content_type }sharedStrings+xml"/>| TO lt_parts.
    APPEND `</Types>` TO lt_parts.
    write_part( io_zip  = lo_zip
                iv_path = `[Content_Types].xml`
                iv_xml  = concat_lines_of( lt_parts ) ).

    rv_content = lo_zip->save( ).
  ENDMETHOD.

  METHOD write_part.
    TRY.
        io_zip->add( name    = iv_path
                     content = cl_abap_conv_codepage=>create_out( )->convert( gc_xml_header && iv_xml ) ).
      CATCH cx_sy_conversion_codepage cx_parameter_invalid_range INTO DATA(lx_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_error ).
    ENDTRY.
  ENDMETHOD.

  METHOD workbook_xml.
    DATA lv_sheet TYPE i.

    rv_xml = |<workbook xmlns="{ gc_main }" xmlns:r="{ gc_relationships }"><sheets>|.
    LOOP AT mt_sheet_names INTO DATA(lv_name).
      lv_sheet = lv_sheet + 1.
      rv_xml = |{ rv_xml }<sheet name="{ xml_escape( lv_name ) }" sheetId="{ lv_sheet }" r:id="rId{ lv_sheet }"/>|.
    ENDLOOP.
    rv_xml = rv_xml && `</sheets></workbook>`.
  ENDMETHOD.

  METHOD worksheet_xml.
    DATA lt_xml TYPE string_table.
    DATA lv_row TYPE i.
    DATA lv_attributes TYPE string.

    APPEND |<worksheet xmlns="{ gc_main }"><sheetData>| TO lt_xml.
    LOOP AT mt_cells INTO DATA(ls_cell) WHERE sheet = iv_sheet.
      IF ls_cell-row <> lv_row.
        IF lv_row > 0.
          APPEND `</row>` TO lt_xml.
        ENDIF.
        lv_row = ls_cell-row.
        APPEND |<row r="{ lv_row }">| TO lt_xml.
      ENDIF.

      DATA(lv_value) = ls_cell-value.
      CLEAR lv_attributes.
      CASE ls_cell-type.
        WHEN gc_type-string.
          lv_value = |{ it_shared_strings[ value = ls_cell-value ]-index }|.
          lv_attributes = ` t="s"`.
        WHEN gc_type-boolean.
          lv_attributes = ` t="b"`.
        WHEN gc_type-error.
          lv_attributes = ` t="e"`.
      ENDCASE.
      IF ls_cell-style <> gc_style-none.
        lv_attributes = |{ lv_attributes } s="{ ls_cell-style }"|.
      ENDIF.

      APPEND |<c r="{ xco_cp_xlsx=>coordinate->for_numeric_value( ls_cell-column )->get_alphabetic_value( ) }{ lv_row }"|
          && |{ lv_attributes }><v>{ xml_escape( lv_value ) }</v></c>| TO lt_xml.
    ENDLOOP.
    IF lv_row > 0.
      APPEND `</row>` TO lt_xml.
    ENDIF.
    APPEND `</sheetData></worksheet>` TO lt_xml.

    rv_xml = concat_lines_of( lt_xml ).
  ENDMETHOD.

  METHOD shared_strings_xml.
    DATA lt_strings TYPE ty_shared_string_list.
    DATA lt_xml TYPE string_table.

    lt_strings = it_shared_strings.
    SORT lt_strings BY index.

    APPEND |<sst xmlns="{ gc_main }" count="{ lines( lt_strings ) }" uniqueCount="{ lines( lt_strings ) }">| TO lt_xml.
    LOOP AT lt_strings INTO DATA(ls_string).
      APPEND |<si><t xml:space="preserve">{ xml_escape( excel_escape( ls_string-value ) ) }</t></si>| TO lt_xml.
    ENDLOOP.
    APPEND `</sst>` TO lt_xml.

    rv_xml = concat_lines_of( lt_xml ).
  ENDMETHOD.

  METHOD styles_xml.
    " cell formats in the order of gc_style: general, date (built-in format 14), time (built-in format 21)
    rv_xml = |<styleSheet xmlns="{ gc_main }">|
          && `<fonts count="1"><font><sz val="11"/><name val="Calibri"/><family val="2"/></font></fonts>`
          && `<fills count="2"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill></fills>`
          && `<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>`
          && `<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>`
          && `<cellXfs count="3"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>`
          && `<xf numFmtId="14" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/>`
          && `<xf numFmtId="21" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/></cellXfs>`
          && `<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>`
          && `</styleSheet>`.
  ENDMETHOD.

  METHOD xml_escape.
    rv_text = iv_text.
    REPLACE ALL OCCURRENCES OF `&` IN rv_text WITH `&amp;`.
    REPLACE ALL OCCURRENCES OF `<` IN rv_text WITH `&lt;`.
    REPLACE ALL OCCURRENCES OF `>` IN rv_text WITH `&gt;`.
    REPLACE ALL OCCURRENCES OF `"` IN rv_text WITH `&quot;`.
  ENDMETHOD.

  METHOD excel_escape.
    DATA lv_code TYPE x LENGTH 1.

    rv_text = iv_text.
    REPLACE ALL OCCURRENCES OF PCRE `_(?=x[0-9A-Fa-f]{4}_)` IN rv_text WITH `_x005F_`.

    " U+0001 to U+001F except tab and line feed
    IF find( val  = rv_text
             pcre = `[\x01-\x08\x0B-\x1F]` ) < 0.
      RETURN.
    ENDIF.
    DO 31 TIMES.
      IF sy-index <> 9 AND sy-index <> 10.
        lv_code = sy-index.
        REPLACE ALL OCCURRENCES OF cl_abap_conv_codepage=>create_in( )->convert( CONV xstring( lv_code ) )
          IN rv_text WITH |_x00{ lv_code }_|.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD excel_unescape.
    DATA lv_offset TYPE i.
    DATA lv_hex TYPE string.

    rv_text = iv_text.
    DO.
      FIND FIRST OCCURRENCE OF PCRE `_x([0-9A-Fa-f]{4})_` IN SECTION OFFSET lv_offset OF rv_text
        MATCH OFFSET lv_offset SUBMATCHES lv_hex.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      rv_text = substring( val = rv_text
                           len = lv_offset )
             && cl_abap_conv_codepage=>create_in( `UTF-16BE` )->convert( CONV xstring( to_upper( lv_hex ) ) )
             && substring( val = rv_text
                           off = lv_offset + 7 ).
      lv_offset = lv_offset + 1.
    ENDDO.
  ENDMETHOD.
ENDCLASS.
