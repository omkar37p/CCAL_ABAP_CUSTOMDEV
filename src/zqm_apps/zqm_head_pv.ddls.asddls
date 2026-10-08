@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COA - Parent Projection View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZQM_HEAD_PV 
provider contract transactional_query
as projection on ZQM_HEAD_RV
{
    key Uuid,
    key Inspection,
    Reportissueon,
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
    Mfgdate,
    Reportno,
    Status,
    Itmcnt,
    Mark,
    Driver,
    Conc,
          @Semantics.largeObject:{
          mimeType: 'coamimetype',
          fileName: 'coafilename',
          contentDispositionPreference: #INLINE
          }       
    Coaattachment,
    Coafilename,
    Coamimetype,
          @Semantics.largeObject:{
          mimeType: 'lapmimetype',
          fileName: 'lapfilename',
          contentDispositionPreference: #INLINE
          }           
    Lapattachment,
    Lapfilename,
    Lapmimetype,
    @Semantics.user.createdBy: true    
    Createdby,
    @Semantics.systemDateTime.createdAt: true    
    Createdat,
    @Semantics.user.lastChangedBy: true    
    Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true    
    Lastchangedat,
    /* Associations */
    _Item
}
