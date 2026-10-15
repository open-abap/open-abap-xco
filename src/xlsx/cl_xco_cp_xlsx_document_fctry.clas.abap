CLASS cl_xco_cp_xlsx_document_fctry DEFINITION PUBLIC FINAL CREATE PRIVATE
  GLOBAL FRIENDS xco_cp_xlsx.

  PUBLIC SECTION.
    INTERFACES if_xco_cp_xlsx_document_fctry.
ENDCLASS.

CLASS cl_xco_cp_xlsx_document_fctry IMPLEMENTATION.
  METHOD if_xco_cp_xlsx_document_fctry~empty.
    ro_document = NEW cl_xco_xlsx_wa_document( cl_xco_xlsx_file=>empty( ) ).
  ENDMETHOD.

  METHOD if_xco_cp_xlsx_document_fctry~for_file_content.
    ro_document = NEW cl_xco_xlsx_ra_document( iv_file_content ).
  ENDMETHOD.
ENDCLASS.
