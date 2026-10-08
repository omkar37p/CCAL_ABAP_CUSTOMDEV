@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Line Item Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP07_IV1
  as select from zmm_app07_tb2
  association        to parent ZMM_APP07_RV as _Header  on  $projection.Uuid = _Header.Uuid
  association [0..*] to ZI_BDGCODE_VH1      as _bdgcode on  $projection.Plant  = _bdgcode.plant
                                                        and $projection.Userid = _bdgcode.userid
{
  key uuid                   as Uuid,
  key purreqitm              as Purreqitm,
      material               as Material,
      matdesc                as Matdesc,
      matgrp                 as Matgrp,
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
      userid                 as Userid,
      deptid                 as Deptid,
      bdgcode                as Bdgcode,
      bdghtxt                as Bdghtxt,
      wbselmt                as Wbselmt,
      delmark                as Delmark,
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
      _Header,
      _bdgcode
}
