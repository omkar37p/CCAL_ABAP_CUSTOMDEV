@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Budget Maintenance App01 - Root CEntity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP01_RCV
  as select from ZMM_APP01_RV
  composition [0..*] of ZMM_APP01_ICV1 as _bdgitm
{
  key Plant,
  key Prodgrp,
      Validon,
      Validto,
      @Semantics.amount.currencyCode: 'Curky'
      Allcbdg,
      Bdghtxt,
      Curky,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.createdBy: true
      Createdby,
      /* Associations */
      _bdgitm
}
