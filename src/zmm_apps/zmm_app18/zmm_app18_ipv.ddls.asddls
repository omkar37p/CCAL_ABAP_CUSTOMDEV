@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZMM_APP18_IPV
  as projection on ZMM_APP18_IV
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
      /* Associations */
      _Header : redirected to parent ZMM_APP18_RPV
}
