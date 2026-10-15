INTERFACE if_xco_xlsx_wa_workbook PUBLIC.
  DATA worksheet TYPE REF TO if_xco_xlsx_wa_worksheet_fctry READ-ONLY.

  " not part of the 2302 release, signature as documented for later releases
  METHODS add_new_sheet
    IMPORTING
      iv_name             TYPE string OPTIONAL
    RETURNING
      VALUE(ro_worksheet) TYPE REF TO if_xco_xlsx_wa_worksheet.
ENDINTERFACE.
