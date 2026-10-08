@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Report - Child Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED 
}
define view entity ZMM_APP11_IV1
  as select from ZI_PURORD_DATA02
  association to parent ZMM_APP11_RV as _hdr on $projection.bdgcode = _hdr.Bdgcode
{
  key    bdgcode,
  key    PurchaseOrder,
  key    PurchaseOrderItem,
         DocumentCurrency,
         PurchasingDocumentDeletionCode,
         Material,
         MaterialType,
         Plant,
         POUNIT,
         NetPriceQuantity,
         IsCompletelyDelivered,
         IsFinallyInvoiced,
         PurchaseRequisition,
         PurchaseRequisitionItem,
         BaseUnit,
         PRICEUNIT,
         @Semantics.quantity.unitOfMeasure: 'POUNIT'
         OrderQuantity,
         @Semantics.amount.currencyCode: 'bdgcurr'
         NetPriceAmount,
         @Semantics.amount.currencyCode: 'bdgcurr'
         netamt,
         @Semantics.amount.currencyCode: 'bdgcurr'
         effamt,
         ExcRate,
         inramt,
         @Semantics.amount.currencyCode: 'bdgcurr'
         bdgamt,
         bdgcurr,
         matdesc,
         POdate,
         status,
         suppname,
         /* Associations */
         _PurchaseOrder,
         _PurOrdAcctAssignment,
         _PurOrdScheduleLine,
         _YY1_allotted_budget_PDI,
         _hdr
}
