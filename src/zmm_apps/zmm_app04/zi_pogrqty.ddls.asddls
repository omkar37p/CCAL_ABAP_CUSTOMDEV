@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total GR Quantity against PO Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_POGRQTY
  as select from I_MaterialDocumentItem_2
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      sum( QuantityInEntryUnit ) as totgrqty
}
where
      GoodsMovementIsCancelled <> 'X'
  and GoodsMovementType        =  '101'
  or  GoodsMovementType        =  '105'
//DebitCreditCode          =  'S'
group by
  PurchaseOrder,
  PurchaseOrderItem,
  EntryUnit
