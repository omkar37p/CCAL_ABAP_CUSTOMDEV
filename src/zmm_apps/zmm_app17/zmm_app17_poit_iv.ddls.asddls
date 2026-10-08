@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Digital Signature Cockpit - PO Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP17_POIT_IV
  as select from ZMM_APP18_ITEM as POI
  association to parent ZMM_APP17_POHD_RV as _Header on $projection.PurchaseOrder = _Header.PurchaseOrder

{
  key POI.PurchaseOrder,
  key POI.PurchaseOrderItem,
      POI.PurchaseOrderCategory,
      POI.PurchaseOrderItemText,
      POI.DocumentCurrency,
      POI.MaterialGroup,
      POI.Material,
      POI.MaterialType,
      POI.BaseUnit,
      POI.CompanyCode,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      POI.NetAmount,
      POI.PurchaseOrderQuantityUnit,
      POI.OrderPriceUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderPriceUnit'
      POI.OrderQuantity,
      POI.Plant,
      POI.TaxCode,
      POI.HSN,
      POI.PurgDocPriceDate as StandardDate,
      POI.Isdeleate,

///Purchase order GST Tax Information
      POI.IGSTContype,
      POI.IGSTConrate,
      POI.IGSTAmount,
      POI.CGSTContype,
      POI.CGSTConrate,
      POI.CSGSTAmount,
//New GST 6 Series GST Tax Information
      POI.IGSTContype6,
      POI.IGSTConrate6,
      POI.IGSTAmount6,
      POI.CGSTContype6,
      POI.CGSTConrate6,
      POI.CSGSTAmount6,
      _Header
}
