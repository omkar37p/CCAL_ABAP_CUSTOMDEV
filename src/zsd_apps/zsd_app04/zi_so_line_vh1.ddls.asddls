@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Item VH1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SO_LINE_VH1
  as select from I_SalesOrderItem       as I
    inner join   ZI_TOTDLVQTY_AGG       as d    on  d.ReferenceSDDocument     = I.SalesOrder
                                                and d.ReferenceSDDocumentItem = I.SalesOrderItem
    inner join   I_ProductDescription_2 as desc on desc.Product = I.Product
    inner join   I_SalesOrder           as h    on h.SalesOrder = I.SalesOrder

{
  key I.SalesOrder                   as SOrder,
  key I.SalesOrderItem,
      I.Plant                        as Shplnt,
      I.Division,
      I.Product                      as Product,
      desc.ProductDescription,
      h.CustomerPurchaseOrderSuplmnt,
      h.CustomerPurchaseOrderDate,
      I.StorageLocation,
      I.SalesOrderItemText,
      I.PurchaseOrderByCustomer,
      h.SoldToParty,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      I.OrderQuantity,
      I.OrderQuantityUnit            as Unit,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      @EndUserText.label: 'Open Order Quantity'
      ( I.OrderQuantity - d.dlvdqty) as opnqty

}
