@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Inward Entry - RE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP15_RV
  as select from zmm_app12_tb2
  composition [0..*] of ZMM_APP15_IV1 as _Item
  association [0..1] to ZMM_APP12_RV  as _HDR on $projection.Uuid = _HDR.Uuid

{
  key uuid          as Uuid,
  key itemno        as Itemno,
      _HDR.Gateno   as Gateno,
      _HDR.Gpnum    as Gpnum,
      _HDR.Gptype   as Gptype,
      matnr         as Matnr,
      maktx         as Maktx,
      uom           as Uom,
      hsncode       as Hsncode,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      quantity      as Quantity,
      curky         as Curky,
      @Semantics.amount.currencyCode: 'Curky'
      netprice      as Netprice,
      @Semantics.amount.currencyCode: 'Curky'
      totvalue      as Totvalue,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      totrcvqty     as Totrcvqty,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      totopnqty     as Totopnqty,
      mark          as Mark,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat,
      _HDR,
      _Item
}
where
  _HDR.Gptype = 'RGP' and _HDR.Mark2 <> 'X'
