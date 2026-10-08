@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COA - Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZPP_QM_COA01_RPV 
provider contract transactional_query
  as projection on ZPP_QM_COA01_RV

{
    key Uuid,
    Inspection,
    Reportissueon,
    Docno,
    Serialno,
    Product,
    Productdesc,
    Ulrnum,
    Discipline,
    Coagroup,
    Customer,
    Truckno,
    Issuedto,
    Partyaddress,
    Reference,
    Samplereceipt,
    Dateofanalyis,
    Batch,
    Description,
    Plant,
    Nablformat,
    Termscond,
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
    _Item : redirected to composition child ZPP_QM_COA01_IPV
}
