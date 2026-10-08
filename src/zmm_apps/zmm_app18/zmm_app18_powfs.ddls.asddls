@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP18_POWFS
  as select from I_WorkflowStatusOverview
{
  key max(WorkflowInternalID) as WorkflowInternalID,
      WorkflowExternalStatus,
      WorkflowScenarioDefinition,
      WorkflowScenarioDefinitionVers,
      SAPObjectNodeRepresentation,
      SAPBusinessObjectNodeKey1

}
where
  WorkflowScenarioDefinition = 'WS00800238'
group by
  WorkflowExternalStatus,
  WorkflowScenarioDefinition,
  WorkflowScenarioDefinitionVers,
  SAPObjectNodeRepresentation,
  SAPBusinessObjectNodeKey1
