" read access to the content of an .xlsx file, the document is also its workbook
" and worksheet factory
CLASS cl_xco_xlsx_ra_document DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS cl_xco_cp_xlsx_document_fctry.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_xlsx_doc_file_contnt.
    INTERFACES if_xco_xlsx_ra_document.
    INTERFACES if_xco_xlsx_ra_workbook.
    INTERFACES if_xco_xlsx_ra_worksheet_fctry.

    METHODS constructor
      IMPORTING
        iv_file_content TYPE xstring.

  PRIVATE SECTION.
    DATA mv_file_content TYPE xstring.
    DATA mo_file TYPE REF TO cl_xco_xlsx_file.
ENDCLASS.

CLASS cl_xco_xlsx_ra_document IMPLEMENTATION.
  METHOD constructor.
    mv_file_content = iv_file_content.
    if_xco_xlsx_ra_workbook~worksheet = me.
  ENDMETHOD.

  METHOD if_xco_cp_xlsx_doc_file_contnt~read_access.
    " raises cx_xco_runtime_exception if the content is not an .xlsx file
    IF mo_file IS NOT BOUND.
      mo_file = cl_xco_xlsx_file=>load( mv_file_content ).
    ENDIF.
    ro_read_access = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_document~get_workbook.
    ro_workbook = me.
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_worksheet_fctry~for_name.
    ro_worksheet = NEW cl_xco_xlsx_worksheet( io_file     = mo_file
                                              iv_position = mo_file->get_sheet_position( iv_name ) ).
  ENDMETHOD.

  METHOD if_xco_xlsx_ra_worksheet_fctry~at_position.
    ro_worksheet = NEW cl_xco_xlsx_worksheet( io_file     = mo_file
                                              iv_position = iv_position ).
  ENDMETHOD.
ENDCLASS.
