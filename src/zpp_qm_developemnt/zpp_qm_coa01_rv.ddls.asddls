@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COA - Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZPP_QM_COA01_RV 
as select from zpp_qm_coa_tb1
  composition [0..*] of ZPP_QM_COA01_IV as _Item
{
    key uuid as Uuid,
    inspection as Inspection,
    reportissueon as Reportissueon,
    docno as Docno,
    serialno as Serialno,
    product as Product,
    productdesc as Productdesc,
    ulrnum as Ulrnum,
    discipline as Discipline,
    coagroup as Coagroup,
    customer as Customer,
    truckno as Truckno,
    issuedto as Issuedto,
    partyaddress as Partyaddress,
    reference as Reference,
    samplereceipt as Samplereceipt,
    dateofanalyis as Dateofanalyis,
    batch as Batch,
    description as Description,
    plant as Plant,
    nablformat as Nablformat,
    termscond as Termscond,
    status as Status,
    itmcnt as Itmcnt,
    mark as Mark,
    @Semantics.user.createdBy: true
    createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    createdat as Createdat,
    @Semantics.user.lastChangedBy: true
    lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    lastchangedat as Lastchangedat,
    _Item
}
