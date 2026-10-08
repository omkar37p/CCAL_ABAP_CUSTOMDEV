@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Processing Projection View  Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZMM_APP14_PV provider contract transactional_query as projection on ZMM_APP14_RV
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
    @Semantics.user.createdBy: true
    Createdby,
    @Semantics.systemDateTime.createdAt: true
    Createdat,
    @Semantics.user.lastChangedBy: true
    Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    Lastchangedat,
    /* Associations */
    _ITM : redirected to composition child ZMM_APP14_IPV
}
