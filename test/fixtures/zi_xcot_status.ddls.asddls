@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'XCO test status'
define view entity ZI_XCOT_STATUS
  as select from zxcot_order
{
  status      as Status,
  description as Description
}
