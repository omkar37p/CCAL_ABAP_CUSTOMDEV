@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales invoice item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSD_APP11_ITEM as select from I_BillingDocumentItemBasic
  association to parent ZSD_APP11_HEADER as _Header on $projection.BillingDocument = _Header.BillingDocument
{
    key BillingDocument,
    key BillingDocumentItem,
        Product,
        BillingDocumentItemText,
        Plant,
        BaseUnit,
        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
        BillingQuantity,
        TransactionCurrency,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
        NetAmount,
        _Header
}
