@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Status'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PO_DELV_STATUS
  as select from I_PurchaseOrderItemAPI01 as POI
{
  key POI.PurchaseOrder         as PurchaseOrder,
  key POI.PurchaseOrderItem     as PurchaseOrderItem,
      POI.YY1_budget_code_PDI   as BudgetCode,
      POI.BaseUnit,
      POI.DocumentCurrency,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      POI.OrderQuantity         as POqty,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      POI.NetPriceAmount        as POrate,
      POI.IsCompletelyDelivered as Status

}
