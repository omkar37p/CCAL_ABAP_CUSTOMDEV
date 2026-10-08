@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item PO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP08_ITEM
  as select from    I_PurchaseOrderItemAPI01 as POI
    left outer join I_ProductPlantBasic      as HSN on  HSN.Product = POI.Material
                                                    and HSN.Plant   = POI.Plant
    left outer join ZMM_APP18_POTAX  as POGST on POGST.PurchaseOrder = POI.PurchaseOrder
                                             and POGST.PurchaseOrderItem = POI.PurchaseOrderItem
{
  key POI.PurchaseOrder,
  key POI.PurchaseOrderItem,
      POI.PurchaseOrderCategory,
      POI.MaterialGroup,
      POI.MaterialType,
      POI.Material,
      POI.PurchaseOrderItemText,
      POI.OrderPriceUnit,
      POI.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      POI.OrderQuantity,
      POI.DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      POI.NetAmount,
      POI.Plant,
      POI.CompanyCode,
      POI.TaxCode,
      POI.PurgDocPriceDate,
      POI.PurchasingDocumentDeletionCode as Isdeleate,
      HSN.ConsumptionTaxCtrlCode as HSN,
      
///PO GST Tax information IGST
      POGST.IGSTContype,
      POGST.IGSTConrate,
      POGST.IGSTAmount,
///PO GST Tax information IGST
      POGST.CGSTContype,
      POGST.CGSTConrate,
      POGST.CSGSTAmount      
              
}
where POI.PurchasingDocumentDeletionCode <> 'L';
