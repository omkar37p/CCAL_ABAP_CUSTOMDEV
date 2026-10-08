@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COA - Parent Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZQM_HEAD_RV
  as select from zqm_head_db
  //composition[0..*] of  ZQM_RESULT_VIEW as _Item
  association [0..*] to ZQM_RESULT_VIEW as _Item on $projection.Inspection = _Item.InspectionLot
{
  key uuid          as Uuid,
  key inspection    as Inspection,
      reportissueon as Reportissueon,
      serialno      as Serialno,
      product       as Product,
      productdesc   as Productdesc,
      ulrnum        as Ulrnum,
      discipline    as Discipline,
      coagroup      as Coagroup,
      customer      as Customer,
      truckno       as Truckno,
      issuedto      as Issuedto,
      partyaddress  as Partyaddress,
      reference     as Reference,
      samplereceipt as Samplereceipt,
      dateofanalyis as Dateofanalyis,
      batch         as Batch,
      description   as Description,
      plant         as Plant,
      nablformat    as Nablformat,
      termscond     as Termscond,
      mfgdate       as Mfgdate,
      reportno      as Reportno,
      status        as Status,
      itmcnt        as Itmcnt,
      mark          as Mark,
      coaattachment as Coaattachment,
      coafilename   as Coafilename,
      coamimetype   as Coamimetype,
      lapattachment as Lapattachment,
      lapfilename   as Lapfilename,
      lapmimetype   as Lapmimetype,
      driver        as Driver,
      conc          as Conc,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat,
      _Item
}
