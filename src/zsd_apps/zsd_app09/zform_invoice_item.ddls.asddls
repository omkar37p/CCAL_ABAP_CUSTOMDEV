@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Form Item Value'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFORM_INVOICE_ITEM
  as select from    I_BillingDocumentItemBasic     as BOI
    inner join      I_BillingDocumentBasic         as BOH  on BOH.BillingDocument = BOI.BillingDocument
    left outer join I_BillingDocumentItemPrcgElmnt as ZPRO on  ZPRO.BillingDocument     = BOI.BillingDocument
                                                           and ZPRO.BillingDocumentItem = BOI.BillingDocumentItem
                                                           and ZPRO.ConditionType       = 'ZPRO'
                                                           and ZPRO.ConditionRateAmount is not initial
    left outer join I_BillingDocumentItemPrcgElmnt as ZFRI on  ZFRI.BillingDocument     = BOI.BillingDocument
                                                           and ZFRI.BillingDocumentItem = BOI.BillingDocumentItem
                                                           and ZFRI.ConditionType       = 'ZFRI'
                                                           and ZFRI.ConditionAmount     is not initial

{
  key BOI.BillingDocument,
  key BOI.BillingDocumentItem,
      BOI.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      BOI.BillingQuantity,
      BOI.TransactionCurrency,
      BOI.Plant,
      case
          when BOI.BaseUnit = 'TO' then 'MTN'
          when BOI.BaseUnit = 'EA' then 'Nos'
          when BOI.BaseUnit = 'M' then 'Mtr'
          when BOI.BaseUnit = 'M3' then 'CBM'
          else BOI.BaseUnit end                                                                                                       as Unit,
      ZPRO.ConditionRateValue                                                                                                         as RateUnit,
      BOH.YY1_FreightIndicatorSD_BDH                                                                                                  as FreightIndicator,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast( ZFRI.ConditionAmount           as abap.dec( 15, 2 ))                                                                      as FreightAmt,
      cast(cast( BOI.BillingQuantity as abap.dec(15,3) ) * cast(ZPRO.ConditionRateValue as abap.dec( 15, 2 ) ) as abap.dec( 15, 2 ) ) as TotalValue
}
