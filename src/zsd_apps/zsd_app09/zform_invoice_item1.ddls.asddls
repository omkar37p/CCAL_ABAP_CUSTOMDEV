@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Invoice Form Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFORM_INVOICE_ITEM1
  as select from ZFORM_INVOICE_ITEM
{
  key BillingDocument,
  key BillingDocumentItem,
      BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      BillingQuantity,
      TransactionCurrency,
      Plant,
      Unit,
      RateUnit,
      FreightIndicator,
      FreightAmt,
      TotalValue,
      cast(cast( coalesce( TotalValue,0 ) as abap.dec( 15, 2 ) ) +
      cast( coalesce( FreightAmt, 0 ) as abap.dec( 15, 2 ) ) as abap.dec( 15, 2 )) as TaxableValue
}
