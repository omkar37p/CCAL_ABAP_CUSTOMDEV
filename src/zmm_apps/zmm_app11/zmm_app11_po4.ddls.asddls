@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Latest Purchase Order'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_APP11_PO4 
as select from I_PurchaseOrderHistoryAPI01
{
      key PurchaseOrder,
      key PurchaseOrderItem,
      IsCompletelyDelivered,
      PurchasingHistoryCategory,
      PurchasingHistoryDocumentItem,
      max( PurchasingHistoryDocument ) as PurchasingHistoryDocument
      
      
}
where PurchasingHistoryCategory = 'E'
  and IsCompletelyDelivered = 'X'
group by
      PurchaseOrder,
      PurchaseOrderItem,
      IsCompletelyDelivered,
      PurchasingHistoryCategory,
      PurchasingHistoryDocumentItem
