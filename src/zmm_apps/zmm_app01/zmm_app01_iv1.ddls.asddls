@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Budget Maintenance App01 - Child Entity1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP01_IV1
  as select from zmm_app01_tb2
{
  key plant     as Plant,
  key prodgrp   as Prodgrp,
  key bdgcode   as Bdgcode,
  key exprdgrp  as Exprdgrp,
      validon   as Validon,
      validto   as Validto,
      @Semantics.amount.currencyCode: 'Curky'
      allcibdg  as Allcibdg,
      @Semantics.amount.currencyCode: 'Curky'
      utlzibdg  as Utlzibdg,
      @Semantics.amount.currencyCode: 'Curky'
      balcibdg  as Balcibdg,
      bdgitxt   as Bdgitxt,
      frbdgcode as Frbdgcode,
      @Semantics.amount.currencyCode: 'Curky'
      splavlbdg as Splavlbdg,
      curky     as Curky,
      @Semantics.systemDateTime.createdAt: true
      lncrtdat  as Lncrtdat,
      @Semantics.user.createdBy: true
      lncrtdby  as Lncrtdby

}
