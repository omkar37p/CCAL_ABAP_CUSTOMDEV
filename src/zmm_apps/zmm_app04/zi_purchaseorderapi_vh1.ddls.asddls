@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PurchaseOrderAPI_VH1
  as select from    I_PurchaseOrderItemAPI01 as p
    left outer join ZI_POGRQTY               as g on  g.PurchaseOrder     = p.PurchaseOrder
                                                  and g.PurchaseOrderItem = p.PurchaseOrderItem
{
  key p.PurchaseOrder,
  key p.PurchaseOrderItem,
      p.Material,
      p.PurchaseOrderItemText,
      p.Plant,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      p.OrderQuantity,
      @UI.hidden: true
      p.PurchaseOrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      @EndUserText.label: 'Total GR Qty'
      g.totgrqty                            as totgrqty,
      @EndUserText.label: 'Open PO Qty'
      //      cast(p.OrderQuantity as menge15_kk ) - cast( g.totgrqty as menge13 ) as opnpoqty
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      case
      when g.totgrqty = 000000000.000
      then p.OrderQuantity
      else
      ( p.OrderQuantity  - g.totgrqty ) end as opnpoqty
}
where
  p.IsCompletelyDelivered <> 'X'
