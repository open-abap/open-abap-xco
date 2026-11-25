@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'XCO test order projection'
define root view entity ZC_XCOT_ORDER
  provider contract transactional_query
  as projection on ZI_XCOT_ORDER
{
  key OrderId,
  key ItemNo,
      Status,
      Description,
      _Status
}
