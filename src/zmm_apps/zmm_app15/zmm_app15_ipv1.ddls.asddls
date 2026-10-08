@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Inward Entry - CPE'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP15_IPV1
  as projection on ZMM_APP15_IV1
{
  key Uuid,
  key Itemno,
  key Sno,
      Matnr,
      Maktx,
      Uom,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      Quantity,
      Indt,
      Intim,
      @EndUserText.label: 'Received Quantity'
//      @Semantics.quantity.unitOfMeasure: 'Uom'
      Recvqty,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      Penqty,
      Invoice,
      Createdby,
      Createdat,
      /* Associations */
      _Header : redirected to parent ZMM_APP15_RPV
}
