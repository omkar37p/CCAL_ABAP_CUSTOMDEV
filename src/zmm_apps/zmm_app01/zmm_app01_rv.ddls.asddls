@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Budget Maintenance App01 - Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP01_RV
  as select from zmm_app01_tb1
{
  key plant     as Plant,
  key prodgrp   as Prodgrp,
      validon   as Validon,
      validto   as Validto,
      @Semantics.amount.currencyCode: 'Curky'
      allcbdg   as Allcbdg,
      bdghtxt   as Bdghtxt,
      curky     as Curky,
      @Semantics.systemDateTime.createdAt: true
      createdat as Createdat,
      @Semantics.user.createdBy: true
      createdby as Createdby
}
