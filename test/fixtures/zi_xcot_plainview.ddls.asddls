@AbapCatalog.sqlViewName: 'ZXCOTPLAINV'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'XCO test plain classic view'
define view ZI_XCOT_PLAINVIEW
  as select from zxcot_node
{
  key node_id as NodeId
}
