@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COA - Child1 Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPP_QM_COA01_IV 
as select from zpp_qm_coa_tb2
   association to parent ZPP_QM_COA01_RV as _Header on $projection.Uuid = _Header.Uuid
{
key uuid as Uuid,
key inspectionitem as Inspectionitem,
inspection as Inspection,
masteric as Masteric,
mastericdes as Mastericdes,
valueunit as Valueunit,
@Semantics.quantity.unitOfMeasure: 'valueunit'
value as Value,
method as Method,
status as Status,
itmcnt as Itmcnt,
mark as Mark,
@Semantics.user.createdBy: true
createdby     as Createdby,
@Semantics.systemDateTime.createdAt: true
createdat     as Createdat,
@Semantics.user.lastChangedBy: true
lastchangedby as Lastchangedby,
@Semantics.systemDateTime.lastChangedAt: true
lastchangedat as Lastchangedat,
_Header
}
