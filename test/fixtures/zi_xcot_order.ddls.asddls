@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'XCO test order'
@ObjectModel.usageType: {
  serviceQuality: #A,
  sizeCategory: #S,
  dataClass: #TRANSACTIONAL
}
define root view entity ZI_XCOT_ORDER
  as select from zxcot_order
  association [0..1] to ZI_XCOT_STATUS as _Status on $projection.Status = _Status.Status
  association [0..*] to ZI_XCOT_NODE   as _Node   on $projection.OrderId = _Node.NodeId
{
  key order_id    as OrderId,
  key item_no     as ItemNo,
      status      as Status,
      description as Description,
      _Status,
      _Node
}
