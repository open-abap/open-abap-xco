@EndUserText.label: 'XCO test table function'
define table function ZF_XCOT_TABFUNC
  returns
  {
    client : abap.clnt;
    Id     : abap.char(10);
  }
  implemented by method zcl_xcot_marker=>get_rows;
