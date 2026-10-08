@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'purchase order 2 report projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zpo_report2_pv 
provider contract transactional_query
as projection on zpo_report2_rv
{
     key PurchaseOrder,
     key PurchaseOrderItem,
     Material,
     Plant,
     ProductName,
     PurchaseOrderQuantityUnit,
     @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
     OrderQuantity,
     DocumentCurrency,
     @Semantics.amount.currencyCode: 'DocumentCurrency'
     NetPriceAmount,
     @Semantics.amount.currencyCode: 'DocumentCurrency'
     Amount,
     MaterialDocument,
     MaterialDocumentYear,
     DocumentDate,
     @Semantics.quantity.unitOfMeasure: 'EntryUnit'
    @DefaultAggregation: #SUM
     QuantityInEntryUnit,
     EntryUnit
}
