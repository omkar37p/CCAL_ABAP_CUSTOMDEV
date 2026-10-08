@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Domestic Invoices Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP08_RV
  as select from zsd_app08_tb1
  composition [0..*] of ZSD_APP08_IV1 as _Item
{
  key bukrs  as Bukrs,
  key vbeln  as Vbeln,
      vkorg  as Vkorg,
      vtweg  as Vtweg,
      spart  as Spart,
      fkart  as Fkart,
      vbtyp  as Vbtyp,
      ernam  as Ernam,
      erdat  as Erdat,
      fkdat  as Fkdat,
      waerk  as Waerk,
      @Semantics.amount.currencyCode : 'waerk'
      netval as Netval,
      @Semantics.amount.currencyCode : 'waerk'
      mwsbk  as Mwsbk,
      konda  as Konda,
      kdgrp  as Kdgrp,
      inco1  as Inco1,
      inco2  as Inco2,
      zterm  as Zterm,
      land1  as Land1,
      regio  as Regio,
      kunrg  as Kunrg,
      belnr  as Belnr,
      xblnr  as Xblnr,
      zuonr  as Zuonr,
      kunag  as Kunag,
      _Item
}
