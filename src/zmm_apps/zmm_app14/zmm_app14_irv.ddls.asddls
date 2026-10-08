@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Processing Projection Child entity 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP14_IRV as select from zmm_app14_itb1 
association TO parent ZMM_APP14_RV AS _HDR ON $projection.Uuid = _HDR.Uuid
composition[1..*] of ZMM_APP14_IIRV AS _ITMCH
{
  key uuid          as Uuid,
  key itemno        as Itemno,
      matnr         as Matnr,
      maktx         as Maktx,
      uom           as Uom,
      hsncode       as Hsncode,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      quantity      as Quantity,
      @Semantics.quantity.unitOfMeasure : 'Uom'
  recvqty    AS Recvqty,
  @Semantics.quantity.unitOfMeasure : 'Uom'
  penqty     as Penqty,
      curky         as Curky,
      @Semantics.amount.currencyCode: 'Curky'
      netprice      as Netprice,
      @Semantics.amount.currencyCode: 'Curky'
      totvalue      as Totvalue,
      mark          as Mark,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat,
    /* Associations */
    _HDR,
    _ITMCH
}
