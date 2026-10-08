@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item View DSC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP18_IV
  as select from ZMM_APP08_ITEM as _Item
  association to parent ZMM_APP18_RV as _Header on $projection.PurchaseOrder = _Header.PurchaseOrder
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      PurchaseOrderCategory,
      MaterialGroup,
      MaterialType,
      Material,
      PurchaseOrderItemText,
      OrderPriceUnit,
      BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      OrderQuantity,
      DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      NetAmount,
      Plant,
      CompanyCode,
      TaxCode,
      PurgDocPriceDate,
      HSN,
      Isdeleate,
      IGSTContype,
      IGSTConrate,
      IGSTAmount,
      CGSTContype,
      CGSTConrate,
      CSGSTAmount,
      _Header
}
