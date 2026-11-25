define hierarchy ZI_XCOT_HIERARCHY
  as parent child hierarchy(
    source ZI_XCOT_NODE
    child to parent association _Parent
    start where ParentId is initial
    siblings order by NodeId
  )
{
  NodeId,
  ParentId
}
