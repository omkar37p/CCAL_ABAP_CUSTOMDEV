@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Budget Maintenance App01 - CP Entity1'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP01_IPV1
  as projection on ZMM_APP01_ICV1
{
  key Plant,
  key Prodgrp,
      @EndUserText.label: 'Plant'
  key Bdgcode,
      @EndUserText.label: 'Department'
  key Exprdgrp,
      Validon,
      Validto,
      @Semantics.amount.currencyCode: 'Curky'
      @EndUserText.label: 'Budget Amount'
      Allcibdg,
      @Semantics.amount.currencyCode: 'Curky'
      Utlzibdg,
      @Semantics.amount.currencyCode: 'Curky'
      Balcibdg,
      @EndUserText.label: 'Budget Code Desc.'
      Bdgitxt,
      Frbdgcode,
      @Semantics.amount.currencyCode: 'Curky'
      Splavlbdg,
      @EndUserText.label: 'Currency'
      Curky,
      @Semantics.systemDateTime.createdAt: true
      Lncrtdat,
      @Semantics.user.createdBy: true
      Lncrtdby,
      /* Associations */
      _bdghdr : redirected to parent ZMM_APP01_RPV
}
