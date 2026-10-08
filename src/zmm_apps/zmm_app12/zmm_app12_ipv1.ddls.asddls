@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Outward Entry - CPE1'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP12_IPV1
  as projection on ZMM_APP12_IV1
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
      Lastchangedat,
      /* Associations */
      _Header : redirected to parent ZMM_APP12_RPV
}
