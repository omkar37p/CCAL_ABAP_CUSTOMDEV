@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Item - Child1 Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP02_IV1
  as select from zmm_app02_tb2
  association to parent ZMM_APP02_RV as _Header on $projection.Uuid = _Header.Uuid
{
  key uuid                   as Uuid,
  key purreqitm              as Purreqitm,
      material               as Material,
      matdesc                as Matdesc,
      matgrp                 as Matgrp,
      extmatgrp              as Extmatgrp,
      plant                  as Plant,
      plantdesc              as Plantdesc,
      purgrp                 as Purgrp,
      purgrpdesc             as Purgrpdesc,
      delvdate               as Delvdate,
      purorg                 as Purorg,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      reqqty                 as Reqqty,
      uom                    as Uom,
      @Semantics.amount.currencyCode: 'Currency'
      valprice               as Valprice,
      @Semantics.amount.currencyCode: 'Currency'
      totvalue               as Totvalue,
      @Semantics.amount.currencyCode: 'Currency'
      alltbdgamt             as Alltbdgamt,
      @Semantics.amount.currencyCode: 'Currency'
      avlbdgamt              as Avlbdgamt,
      currency               as Currency,
      @Semantics.user.createdBy: true
      itemcreatedby          as ItemCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      itemcreatedat          as ItemCreatedAt,
      @Semantics.user.lastChangedBy: true
      itemlastchangedby      as ItemLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      itemlastchangedat      as ItemLastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      itemlocallastchangedat as ItemLocalLastChangedAt,
      _Header
}
