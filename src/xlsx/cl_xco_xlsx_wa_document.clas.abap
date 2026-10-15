" write access to a new .xlsx file, the document is also its workbook and worksheet factory
CLASS cl_xco_xlsx_wa_document DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_cp_xlsx_document_fctry.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_xlsx_doc_empty.
    INTERFACES if_xco_xlsx_wa_document.
    INTERFACES if_xco_xlsx_wa_workbook.
    INTERFACES if_xco_xlsx_wa_worksheet_fctry.

    METHODS constructor
      IMPORTING
        io_file TYPE REF TO cl_xco_xlsx_file.

  PRIVATE SECTION.
    DATA mo_file TYPE REF TO cl_xco_xlsx_file.
ENDCLASS.

CLASS cl_xco_xlsx_wa_document IMPLEMENTATION.
  METHOD constructor.
    mo_file = io_file.
    if_xco_xlsx_wa_workbook~worksheet = me.
  ENDMETHOD.

  METHOD if_xco_cp_xlsx_doc_empty~write_access.
    ro_write_access = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_document~get_workbook.
    ro_workbook = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_document~get_file_content.
    rv_file_content = mo_file->save( ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_workbook~add_new_sheet.
    mo_file->add_sheet( iv_name ).
    ro_worksheet = NEW cl_xco_xlsx_worksheet( io_file     = mo_file
                                              iv_position = mo_file->get_sheet_count( ) ).
  ENDMETHOD.

  METHOD if_xco_xlsx_wa_worksheet_fctry~at_position.
    ro_worksheet = NEW cl_xco_xlsx_worksheet( io_file     = mo_file
                                              iv_position = iv_position ).
  ENDMETHOD.
ENDCLASS.
