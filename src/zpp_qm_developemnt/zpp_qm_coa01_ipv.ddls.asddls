@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COA - Child1 PEntity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZPP_QM_COA01_IPV 
as projection on ZPP_QM_COA01_IV
{
    key Uuid,
    key Inspectionitem,
    Inspection,
    Masteric,
    Mastericdes,
    Valueunit,
    @Semantics.quantity.unitOfMeasure: 'Valueunit'
    Value,
    Method,
    Status,
    Itmcnt,
    Mark,
    @Semantics.user.createdBy: true
    Createdby,
    @Semantics.systemDateTime.createdAt: true
    Createdat,
    @Semantics.user.lastChangedBy: true
    Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    Lastchangedat,
    /* Associations */
    _Header : redirected to parent ZPP_QM_COA01_RPV
}
