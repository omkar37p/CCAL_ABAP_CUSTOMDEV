@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales invoice item print'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSD_APP11_ITEM_PRINT as select from ZSD_APP11_ITEM
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
    NetAmount
}
