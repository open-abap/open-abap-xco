" the row stream operations: write_to reads the selection into an internal table,
" write_from writes an internal table into the selection; the n-th field of a table
" line is the n-th column of the selection
CLASS cl_xco_xlsx_row_operation DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_xlsx_selection.

  PUBLIC SECTION.
    INTERFACES if_xco_xlsx_ra_rs_op_write_to.
    INTERFACES if_xco_xlsx_wa_rs_op_write_frm.

    METHODS constructor
      IMPORTING
        io_file   TYPE REF TO cl_xco_xlsx_file
        iv_sheet  TYPE i
        is_bounds TYPE cl_xco_xlsx_slc_pattern=>ty_bounds
        ir_table  TYPE REF TO data.

  PRIVATE SECTION.
    TYPES ty_fields TYPE STANDARD TABLE OF REF TO data WITH EMPTY KEY.

    DATA mo_file TYPE REF TO cl_xco_xlsx_file.
    DATA mv_sheet TYPE i.
    DATA ms_bounds TYPE cl_xco_xlsx_slc_pattern=>ty_bounds.
    DATA mr_table TYPE REF TO data.
    DATA mo_transformation TYPE REF TO cl_xco_xlsx_value_trnsfrmtn.

    METHODS assert_table.

    " the fields of a line that are in the columns of the selection; raises
    " cx_xco_runtime_exception for fields that are not elementary
    METHODS fields_of
      IMPORTING
        ir_line          TYPE REF TO data
      RETURNING
        VALUE(rt_fields) TYPE ty_fields.

    METHODS result
      RETURNING
        VALUE(ro_result) TYPE REF TO if_xco_dp_action_result.
ENDCLASS.

CLASS cl_xco_xlsx_row_operation IMPLEMENTATION.
  METHOD constructor.
    mo_file = io_file.
    mv_sheet = iv_sheet.
    ms_bounds = is_bounds.
    mr_table = ir_table.
    " best effort is the default of read and write access
    mo_transformation ?= xco_cp_xlsx_read_access=>value_transformation->best_effort->if_xco_xlsx_ra_vt_row_value~get_implementation( ).
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_rs_op_write_to~set_value_transformation.
    mo_transformation ?= io_value_transformation->get_implementation( ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_rs_op_write_frm~set_value_transformation.
    mo_transformation ?= io_value_transformation->get_implementation( ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_operation~get_action.
    " actions of the XCO data processing framework are not available
    RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_operation~get_action.
    " actions of the XCO data processing framework are not available
    RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_operation~execute.
    " the rows from the first row of the selection to the last one with a value
    DATA lr_line TYPE REF TO data.
    DATA lv_column TYPE i.
    FIELD-SYMBOLS <lt_table> TYPE ANY TABLE.
    FIELD-SYMBOLS <ls_line> TYPE any.
    FIELD-SYMBOLS <lv_field> TYPE any.

    assert_table( ).
    ASSIGN mr_table->* TO <lt_table>.
    CREATE DATA lr_line LIKE LINE OF <lt_table>.
    ASSIGN lr_line->* TO <ls_line>.
    DATA(lt_fields) = fields_of( lr_line ).

    DATA(lv_last_row) = nmin( val1 = ms_bounds-to_row
                              val2 = mo_file->get_last_row( iv_sheet       = mv_sheet
                                                            iv_from_column = ms_bounds-from_column
                                                            iv_to_column   = ms_bounds-to_column ) ).
    DATA(lv_row) = ms_bounds-from_row.
    WHILE lv_row <= lv_last_row.
      CLEAR <ls_line>.
      LOOP AT lt_fields INTO DATA(lr_field).
        lv_column = ms_bounds-from_column + sy-tabix - 1.
        READ TABLE mo_file->mt_cells WITH TABLE KEY sheet  = mv_sheet
                                                    row    = lv_row
                                                    column = lv_column INTO DATA(ls_cell).
        IF sy-subrc = 0.
          ASSIGN lr_field->* TO <lv_field>.
          mo_transformation->read( EXPORTING is_cell  = ls_cell
                                   CHANGING  cv_field = <lv_field> ).
        ENDIF.
      ENDLOOP.
      INSERT <ls_line> INTO TABLE <lt_table>.
      lv_row = lv_row + 1.
    ENDWHILE.

    ro_result = result( ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_operation~execute.
    " one row per table line from the first row of the selection on
    DATA lr_line TYPE REF TO data.
    DATA ls_cell TYPE cl_xco_xlsx_file=>ty_cell.
    FIELD-SYMBOLS <lt_table> TYPE ANY TABLE.
    FIELD-SYMBOLS <lv_field> TYPE any.

    assert_table( ).
    ASSIGN mr_table->* TO <lt_table>.

    DATA(lv_row) = ms_bounds-from_row.
    LOOP AT <lt_table> REFERENCE INTO lr_line.
      IF lv_row > ms_bounds-to_row.
        EXIT.
      ENDIF.
      DATA(lt_fields) = fields_of( lr_line ).
      LOOP AT lt_fields INTO DATA(lr_field).
        DATA(lv_column) = ms_bounds-from_column + sy-tabix - 1.
        ASSIGN lr_field->* TO <lv_field>.
        ls_cell = mo_transformation->write( <lv_field> ).
        ls_cell-sheet = mv_sheet.
        ls_cell-row = lv_row.
        ls_cell-column = lv_column.
        mo_file->set_cell( ls_cell ).
      ENDLOOP.
      lv_row = lv_row + 1.
    ENDLOOP.

    ro_result = result( ).
  ENDMETHOD.

  METHOD assert_table.
    IF mr_table IS NOT BOUND OR cl_abap_typedescr=>describe_by_data_ref( mr_table )->kind <> cl_abap_typedescr=>kind_table.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
  ENDMETHOD.

  METHOD fields_of.
    DATA lv_count TYPE i.
    DATA lr_field TYPE REF TO data.
    FIELD-SYMBOLS <ls_line> TYPE any.
    FIELD-SYMBOLS <lv_field> TYPE any.

    ASSIGN ir_line->* TO <ls_line>.
    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( <ls_line> ).
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_elem.
        lv_count = 1.
      WHEN cl_abap_typedescr=>kind_struct.
        lv_count = lines( CAST cl_abap_structdescr( lo_type )->components ).
      WHEN OTHERS.
        RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDCASE.
    lv_count = nmin( val1 = lv_count
                     val2 = ms_bounds-to_column - ms_bounds-from_column + 1 ).

    DO lv_count TIMES.
      IF lo_type->kind = cl_abap_typedescr=>kind_elem.
        ASSIGN <ls_line> TO <lv_field>.
      ELSE.
        ASSIGN COMPONENT sy-index OF STRUCTURE <ls_line> TO <lv_field>.
        IF sy-subrc <> 0 OR cl_abap_typedescr=>describe_by_data( <lv_field> )->kind <> cl_abap_typedescr=>kind_elem.
          RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
        ENDIF.
      ENDIF.
      GET REFERENCE OF <lv_field> INTO lr_field.
      APPEND lr_field TO rt_fields.
    ENDDO.
  ENDMETHOD.

  METHOD result.
    ro_result = NEW cl_xco_dp_action_result( ).
  ENDMETHOD.
ENDCLASS.
