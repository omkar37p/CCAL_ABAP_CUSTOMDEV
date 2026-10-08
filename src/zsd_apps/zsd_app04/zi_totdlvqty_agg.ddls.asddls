@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Line Total Delivered Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TOTDLVQTY_AGG
  as select from I_DeliveryDocumentItem
{
  key ReferenceSDDocument,
  key ReferenceSDDocumentItem,
      DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      sum( ActualDeliveryQuantity ) as dlvdqty
}
where
  SDDocumentCategory = 'J'
group by
  ReferenceSDDocument,
  ReferenceSDDocumentItem,
  DeliveryQuantityUnit
