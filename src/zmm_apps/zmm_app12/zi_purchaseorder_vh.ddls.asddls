@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Help For Purchase Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASEORDER_VH as select from ZI_PurchaseOrderAPI_VH1
{
    key PurchaseOrder,
    key PurchaseOrderItem,
    Material,
    PurchaseOrderItemText,
    Plant,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    OrderQuantity,
    @UI.hidden: true
    PurchaseOrderQuantityUnit

}
