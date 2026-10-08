@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Budget Maintenance App01 - Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP01_RPV
  provider contract transactional_query
  as projection on ZMM_APP01_RCV
{
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Material Group'
  key Prodgrp,
      Validon,
      Validto,
      @Semantics.amount.currencyCode: 'Curky'
      @EndUserText.label: 'Allotted Amount'
      Allcbdg,
      @EndUserText.label: 'Budget Header Desc.'
      Bdghtxt,
      Curky,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.createdBy: true
      Createdby,
      /* Associations */
      _bdgitm : redirected to composition child ZMM_APP01_IPV1
}
