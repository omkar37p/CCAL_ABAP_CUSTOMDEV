@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Invoice Item CDS View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_INVOICE_ITEM
  as select from I_BillingDocumentBasic     as _Bhd
    inner join   I_BillingDocumentItemBasic as _bid on _bid.BillingDocument = _Bhd.BillingDocument
    left outer join I_ProductPlantBasic as _Hsn on _Hsn.Product = _bid.Product
                                and _Hsn.Plant = _bid.Plant
                left outer join I_BillingDocumentItemPrcgElmnt as ZPRO on ZPRO.BillingDocument = _bid.BillingDocument
                                                                  and ZPRO.BillingDocumentItem = _bid.BillingDocumentItem
                                                                  and ZPRO.ConditionType = 'ZPRO'
                                                                  and ZPRO.ConditionRateAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as IGST on IGST.BillingDocument = _bid.BillingDocument
                                                                  and IGST.BillingDocumentItem = _bid.BillingDocumentItem
                                                                  and IGST.ConditionType = 'JOIG'
                                                                  and IGST.ConditionAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as CGST on CGST.BillingDocument = _bid.BillingDocument
                                                                  and CGST.BillingDocumentItem = _bid.BillingDocumentItem
                                                                  and CGST.ConditionType = 'JOCG'
                                                                  and CGST.ConditionAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as SGST on SGST.BillingDocument = _bid.BillingDocument
                                                                  and SGST.BillingDocumentItem = _bid.BillingDocumentItem
                                                                  and SGST.ConditionType = 'JOSG'
                                                                  and SGST.ConditionAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as RoundOff on RoundOff.BillingDocument = _bid.BillingDocument
                                                                  and RoundOff.BillingDocumentItem = _bid.BillingDocumentItem
                                                                  and RoundOff.ConditionType = 'DRD1'
                                                                  and RoundOff.ConditionAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as ZFRI on ZFRI.BillingDocument = _bid.BillingDocument
                                                                  and ZFRI.BillingDocumentItem = _bid.BillingDocumentItem
                                                                  and ZFRI.ConditionType = 'ZFRI'
                                                                  and ZFRI.ConditionRateAmount is not initial                                                                  
         
{
    key _bid.BillingDocument,
    key _bid.BillingDocumentItem,
        _bid.Batch,
        _bid.BaseUnit,
        _bid.Product,
        _bid.BillingDocumentItemText,
        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
        _bid.ItemNetWeight,
        _bid.TransactionCurrency,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
        _bid.NetAmount,
        _Hsn.ConsumptionTaxCtrlCode,
        ZPRO.ConditionRateValue as RateUnit,
        @Semantics.amount.currencyCode: 'TransactionCurrency'        
        ZPRO.ConditionAmount as TotalValue,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
        IGST.ConditionAmount as IGSTAmount,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
        CGST.ConditionAmount  as CGSTAmount,
        @Semantics.amount.currencyCode: 'TransactionCurrency'        
        SGST.ConditionAmount as SGSTAmount,
        @Semantics.amount.currencyCode: 'TransactionCurrency'        
        RoundOff.ConditionAmount as RoundoffAmount,
        @Semantics.amount.currencyCode: 'TransactionCurrency'        
        ZFRI.ConditionAmount as FreightAmount
}
