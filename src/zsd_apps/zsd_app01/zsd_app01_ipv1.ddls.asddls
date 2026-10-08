@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Gate Entry - Item PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_APP01_IPV1
  as projection on ZSD_APP01_IV1
{
  key Uuid,
  key Soitem,
      Division,
      Material,
      Matdesc,
      Batch,
      Plant,
      Sloc,
      @Semantics.quantity.unitOfMeasure: 'Ordunt'
      Ordqty,
      Ordunt,
      /* Associations */
      _Header : redirected to parent ZSD_APP01_RPV
}
