@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales invoice item PV'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZSD_APP11_ITEM_PV as projection on ZSD_APP11_ITEM
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
      /* Associations */
      _Header : redirected to parent ZSD_APP11_HEADER_PV    
}
