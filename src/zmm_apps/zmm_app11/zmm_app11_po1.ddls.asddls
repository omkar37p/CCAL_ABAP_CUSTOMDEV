@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Report - PO data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED 
}
define view entity ZMM_APP11_PO1
  as select from I_PurchaseRequisitionItemAPI01 as pr
    inner join   I_PurchaseOrderItemAPI01       as po on  po.PurchaseOrder     = pr.PurchasingDocument
                                                      and po.PurchaseOrderItem = pr.PurchasingDocumentItem
{
  key pr.PurchaseRequisition,
  key pr.PurchaseRequisitionItem,
      pr.PurchasingDocument,
      pr.PurchasingDocumentItem,
      pr.PurReqnItemCurrency,
      pr.YY1_WBSElementIntID_PRI,
      @Semantics.amount.currencyCode: 'PurReqnItemCurrency'
      pr.YY1_allotted_budget_PRI,
      pr.YY1_allotted_budget_PRIC,
      pr.YY1_budget_code_PRI,
      po.Material,
      po.Plant,
      po.PurchaseOrderItemText,
      po.PurchaseOrderQuantityUnit,
      po.DocumentCurrency,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      po.OrderQuantity,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      po.NetPriceAmount


}
