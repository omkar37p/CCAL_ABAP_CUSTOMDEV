@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Processing Projection View View Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZMM_APP13_PV1 provider contract transactional_query as projection on  ZMM_APP13_RV1
{
    key Uuid,
    Plant,
    Plantname,
    Gpnum,
    Gptype,
    Vendnum,
    Vendname,
    Plnrtndate,
    Vehicleno,
    Dispby,
    Issuedate,
    Issuedby,
    Transporter,
    Remarks,
    @Semantics.amount.currencyCode: 'Curky'
    Gpvalue,
    Curky,
    Rsngp,
    Frghtscope,
    Pcklist,
    Delmark,
    Mark,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
    _Item 
  
}
