@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Workflow Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP17_POWFS 
as select from I_WorkflowStatusOverview
{
    key max(WorkflowInternalID) as WorkflowInternalID,
    max(WorkflowExternalStatus) as WorkflowExternalStatus,
    WorkflowScenarioDefinition,
    WorkflowScenarioDefinitionVers,
    SAPObjectNodeRepresentation,
    SAPBusinessObjectNodeKey1
    
} where WorkflowScenarioDefinition = 'WS00800238' 
    and  WorkflowExternalStatus <> 'ERROR'
    and WorkflowExternalStatus <> 'CANCELLED' 
 group by
    WorkflowScenarioDefinition,
    WorkflowScenarioDefinitionVers,
    SAPObjectNodeRepresentation,
    SAPBusinessObjectNodeKey1
 
