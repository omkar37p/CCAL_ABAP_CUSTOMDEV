@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zmm_app16_V as select from ZMM_APP12_IV1
{
   key Uuid,
   key Itemno,
   Matnr,
   Maktx,
   Uom,
   Hsncode,
   @Semantics.quantity.unitOfMeasure: 'Uom'
      Quantity,
      Curky,
      @Semantics.amount.currencyCode: 'Curky'
      Netprice,
      @Semantics.amount.currencyCode: 'Curky'
      Totvalue,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      Totrcvqty,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      Totopnqty,
      Mark,
      @Semantics.user.createdBy: true
      Createdby,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.lastChangedBy: true
      Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat
   /* Associations */
//   _Header
}
