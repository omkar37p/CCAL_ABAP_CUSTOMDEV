@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Processing Root View Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP14_RV as select from zmm_app14_htb1 
composition[0..*] of ZMM_APP14_IRV as _ITM
{
key uuid          as Uuid,
      plant         as Plant,
      plantname     as Plantname,
      gpnum         as Gpnum,
      gptype        as Gptype,
      vendnum       as Vendnum,
      vendname      as Vendname,
      plnrtndate    as Plnrtndate,
      vehicleno     as Vehicleno,
      dispby        as Dispby,
      issuedate     as Issuedate,
      issuedby      as Issuedby,
      transporter   as Transporter,
      remarks       as Remarks,
      @Semantics.amount.currencyCode: 'Curky'
      gpvalue       as Gpvalue,
      curky         as Curky,
      rsngp         as Rsngp,
      frghtscope    as Frghtscope,
      pcklist       as Pcklist,
      delmark       as Delmark,
      mark          as Mark,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat,
    _ITM
}
