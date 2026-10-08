@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Invoice Item Tax Condition'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFORM_INVOICE_CON 
  as select from    I_BillingDocumentItemBasic     as bdi
    left outer join I_BillingDocumentItemPrcgElmnt as IGST     on  IGST.BillingDocument     = bdi.BillingDocument
                                                               and IGST.BillingDocumentItem = bdi.BillingDocumentItem
                                                               and IGST.ConditionType       = 'JOIG'
                                                               and IGST.ConditionAmount     is not initial
    left outer join I_BillingDocumentItemPrcgElmnt as CGST     on  CGST.BillingDocument     = bdi.BillingDocument
                                                               and CGST.BillingDocumentItem = bdi.BillingDocumentItem
                                                               and CGST.ConditionType       = 'JOCG'
                                                               and CGST.ConditionAmount     is not initial
    left outer join I_BillingDocumentItemPrcgElmnt as SGST     on  SGST.BillingDocument     = bdi.BillingDocument
                                                               and SGST.BillingDocumentItem = bdi.BillingDocumentItem
                                                               and SGST.ConditionType       = 'JOSG'
                                                               and SGST.ConditionAmount     is not initial
    left outer join I_BillingDocumentItemPrcgElmnt as RoundOff on  RoundOff.BillingDocument     = bdi.BillingDocument
                                                               and RoundOff.BillingDocumentItem = bdi.BillingDocumentItem
                                                               and RoundOff.ConditionType       = 'DRD1'
                                                               and RoundOff.ConditionAmount     is not initial
    left outer join I_BillingDocumentItemPrcgElmnt as tsc      on  tsc.BillingDocument     = bdi.BillingDocument
                                                               and tsc.BillingDocumentItem = bdi.BillingDocumentItem
                                                               and tsc.ConditionType       = 'JTC1'
                                                               and tsc.ConditionAmount is not initial

{
  key bdi.BillingDocument,
      bdi.TransactionCurrency,
      cast( IGST.ConditionRateValue as abap.dec( 2, 0 )) as IGSTRate,
      IGST.ConditionRateRatioUnit as IGSTRatiounit, 
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( IGST.ConditionAmount )        as IGSTAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( CGST.ConditionAmount )        as CGSTAmount,
      cast( CGST.ConditionRateValue as abap.dec( 2, 0 )) as CGSTRate,
      CGST.ConditionRateRatioUnit as CGSTRatiounit,       
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( SGST.ConditionAmount  )       as SGSTAmount,
      cast( SGST.ConditionRateValue as abap.dec( 2, 0 )) as SGSTRate,
      SGST.ConditionRateRatioUnit as SGSTRatiounit,      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( RoundOff.ConditionAmount )     as RoundoffAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( tsc.ConditionAmount )         as TCSAmount                          
}
group by bdi.BillingDocument,
         bdi.TransactionCurrency,
         IGST.ConditionRateValue,
         IGST.ConditionRateRatioUnit,
         CGST.ConditionRateValue,
         CGST.ConditionRateRatioUnit,
         SGST.ConditionRateValue,
         SGST.ConditionRateRatioUnit                   
