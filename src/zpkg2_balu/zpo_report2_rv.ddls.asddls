@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'purchase order 2 report root view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zpo_report2_rv 
as select from I_PurchaseOrderAPI01 as poh
inner join I_PurchaseOrderItemAPI01 as poi on poh.PurchaseOrder = poi.PurchaseOrder
inner join I_ProductText as ptxt on poi.Material = ptxt.Product and ptxt.Language = $session.system_language
left outer join I_MaterialDocumentItem_2 as mdi on poh.PurchaseOrder = mdi.PurchaseOrder and poi.PurchaseOrderItem = mdi.PurchaseOrderItem

{
     key poh.PurchaseOrder,
     key poi.PurchaseOrderItem,
     poi.Material,
     poi.Plant,
     poi.PurchaseOrderQuantityUnit,
     @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit' 
     poi.OrderQuantity,
     poi.DocumentCurrency,
     @Semantics.amount.currencyCode: 'DocumentCurrency'
     poi.NetPriceAmount,
     ptxt.ProductName ,
     @Semantics.amount.currencyCode: 'DocumentCurrency'
    cast(cast(poi.OrderQuantity as abap.dec( 13, 2)) * cast(poi.NetPriceAmount as abap.dec(13, 2)) as abap.curr(13, 2)) as Amount,
    mdi.MaterialDocument,
    mdi.MaterialDocumentYear,
    mdi.DocumentDate,
    @Semantics.quantity.unitOfMeasure: 'EntryUnit'
    @DefaultAggregation: #SUM
    mdi.QuantityInEntryUnit,
    mdi.EntryUnit
    
}
