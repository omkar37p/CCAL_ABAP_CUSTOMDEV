@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Goods Movements Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_MIGO_ITEM
  as select from I_MaterialDocumentItem_2 as MOI
  left outer join I_ProductDescription as matdes on matdes.Product = MOI.Material   
                                                  and matdes.Language = $session.system_language
  left outer join I_PurchaseOrderItemAPI01 as POI on POI.PurchaseOrder = MOI.PurchaseOrder
                                            and POI.PurchaseOrderItem = MOI.PurchaseOrderItem
{
    key MOI.MaterialDocument,
    key MOI.MaterialDocumentYear,
    key MOI.MaterialDocumentItem,
        MOI.Plant,
        MOI.CompanyCode,
        MOI.CompanyCodeCurrency,
        MOI.Material,
        matdes.ProductDescription,
        MOI.MaterialBaseUnit,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'        
        MOI.QuantityInBaseUnit as MigoQty,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        POI.OrderQuantity as POQty,
        POI.PurchaseOrder,
        POI.PurchaseOrderItem
  }
