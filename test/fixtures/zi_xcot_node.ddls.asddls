@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'XCO test hierarchy node'
define view entity ZI_XCOT_NODE
  as select from zxcot_node
  association [0..1] to ZI_XCOT_NODE as _Parent on $projection.ParentId = _Parent.NodeId
{
  key node_id   as NodeId,
      parent_id as ParentId,
      _Parent
}
