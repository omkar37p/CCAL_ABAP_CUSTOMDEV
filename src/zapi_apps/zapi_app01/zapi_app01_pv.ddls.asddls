@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice APIs Projection View Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZAPI_APP01_PV
  as select from ZAPI_APP01_RV
{
  key BillingDocument,
  key BillingDocumentItem,
      BillDate,
      BillingDocumentType,
      VoucherType,
      ODNNumber,
      Product,
      BillingDocumentItemText,
      Plant,
      BaseUnit,
      curr,
      @Semantics.amount.currencyCode: 'curr'
      TaxbleValue,
      @Semantics.amount.currencyCode: 'curr'
      TaxAmount,
      @Semantics.amount.currencyCode: 'curr'
      totalvalue,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      Quantity,
      CustomerName,
      BaseValue,
      Freight,
      igstvalue,
      cgstvalue,
      sgstvalue,
      tcsvalue,
      CreationDate,
      CreationTime
}
