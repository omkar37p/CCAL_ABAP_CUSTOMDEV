@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Domestic Invoices Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP08_RPV
  provider contract transactional_query
  as projection on ZSD_APP08_RV
{
  key Bukrs,
  key Vbeln,
      Vkorg,
      Vtweg,
      Spart,
      Fkart,
      Vbtyp,
      Ernam,
      Erdat,
      Fkdat,
      Waerk,
      @Semantics.amount.currencyCode : 'waerk'
      Netval,
      @Semantics.amount.currencyCode : 'waerk'
      Mwsbk,
      Konda,
      Kdgrp,
      Inco1,
      Inco2,
      Zterm,
      Land1,
      Regio,
      Kunrg,
      Belnr,
      Xblnr,
      Zuonr,
      Kunag,
      /* Associations */
      _Item : redirected to composition child ZSD_APP08_IPV1
}
