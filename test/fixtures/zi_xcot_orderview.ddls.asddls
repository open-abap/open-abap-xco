@AbapCatalog.sqlViewName: 'ZXCOTORDERV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'XCO test classic view'
define view ZI_XCOT_ORDERVIEW
  as select from zxcot_order
  association [0..1] to ZI_XCOT_STATUS as _Status on $projection.Status = _Status.Status
{
  key order_id as OrderId,
  key item_no  as ItemNo,
      status   as Status,
      _Status
}
