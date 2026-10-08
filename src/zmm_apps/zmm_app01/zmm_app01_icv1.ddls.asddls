@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Budget App01 - Child CEntity1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP01_ICV1
  as select from ZMM_APP01_IV1
  association to parent ZMM_APP01_RCV as _bdghdr on  $projection.Plant   = _bdghdr.Plant
                                                 and $projection.Prodgrp = _bdghdr.Prodgrp           
{
  key Plant,
  key Prodgrp,
  key Bdgcode,
  key Exprdgrp,
      Validon,
      Validto,
      @Semantics.amount.currencyCode: 'Curky'
      Allcibdg,
      @Semantics.amount.currencyCode: 'Curky'
      Utlzibdg,
      @Semantics.amount.currencyCode: 'Curky'
      Balcibdg,
      Bdgitxt,
      Frbdgcode,
      @Semantics.amount.currencyCode: 'Curky'
      Splavlbdg,
      Curky,
      @Semantics.systemDateTime.createdAt: true
      Lncrtdat,
      @Semantics.user.createdBy: true
      Lncrtdby,
      /* Associations */
      _bdghdr
}
