@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Outward Entry - CE1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP12_IV1
  as select from zmm_app12_tb2
  association to parent ZMM_APP12_RV as _Header on $projection.Uuid = _Header.Uuid
{
  key uuid          as Uuid,
  key itemno        as Itemno,
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
      _Header
}
