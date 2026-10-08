@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Inward Entry - RPE'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP15_RPV
  provider contract transactional_query
  as projection on ZMM_APP15_RV
{
  key Uuid,
  key Itemno,
  Gateno,
      Gpnum,
      Gptype,
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
      _HDR,
      _Item : redirected to composition child ZMM_APP15_IPV1
}
