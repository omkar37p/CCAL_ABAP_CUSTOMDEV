@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Domestic Invoices  Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFDP_DMINV02
  as select from    I_BillingDocumentItemBasic     as bdi
    left outer join I_ProductPlantBasic            as _Hsn     on  _Hsn.Product = bdi.Product
                                                               and _Hsn.Plant   = bdi.Plant
    left outer join I_ProductDescription_2         as _Des     on _Des.Product = bdi.Product
    left outer join I_BillingDocumentItemPrcgElmnt as ZPRO     on  ZPRO.BillingDocument     = bdi.BillingDocument
                                                               and ZPRO.BillingDocumentItem = bdi.BillingDocumentItem
                                                               and ZPRO.ConditionType       = 'ZPRO'
                                                               and ZPRO.ConditionRateAmount is not initial
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
    left outer join I_BillingDocumentItemPrcgElmnt as ZFRI     on  ZFRI.BillingDocument     = bdi.BillingDocument
                                                               and ZFRI.BillingDocumentItem = bdi.BillingDocumentItem
                                                               and ZFRI.ConditionType       = 'ZFRI'
                                                               and ZFRI.ConditionRateAmount is not initial
    left outer join I_BillingDocumentItemPrcgElmnt as tsc      on  tsc.BillingDocument     = bdi.BillingDocument
                                                               and tsc.BillingDocumentItem = bdi.BillingDocumentItem
                                                               and tsc.ConditionType       = 'JTC1'
                                                               and tsc.ConditionRateAmount is not initial

{
  key bdi.CompanyCode              as ccode,
  key bdi.BillingDocument          as billdoc,
  key bdi.BillingDocumentItem      as billitm,
      bdi.Product                  as product,
      @Semantics.quantity.unitOfMeasure: 'unit'
      bdi.BillingQuantity          as billqty,
      bdi.BillingQuantityUnit      as unit,
      @Semantics.amount.currencyCode: 'curky'
      bdi.NetAmount                as netamt,
      bdi.TransactionCurrency      as curky,
      bdi.BillingDocumentItemText  as Itemtxt,
      bdi.Batch                    as Batch,
      bdi.Plant                    as Plant,
      _Hsn.ConsumptionTaxCtrlCode  as hsnno,
      _Des.ProductDescription      as Matdesc,
      ZPRO.ConditionRateValue      as RateUnit,
      @Semantics.amount.currencyCode: 'curky'
      ZPRO.ConditionAmount         as ConditionAmount_zpro,
      ZPRO.ConditionBaseValue      as BaseValue_zpro,
      ZPRO.ConditionScaleBasisUnit as BaseValueUnit_zpro,
      ZPRO.ConditionQuantity       as ConditionQuantity_zpro,
      ZPRO.ConditionQuantityUnit   as QuantityUnit_zpro,
      ZPRO.ConditionType           as ConditionType_zpro,
      ZPRO.ConditionCurrency       as ConditionCurrency_zpro,
      ZPRO.ConditionRateAmount     as ConditionRateAmount_zpro,
      @Semantics.amount.currencyCode: 'curky'
      IGST.ConditionAmount         as ConditionAmount_IGST,
      IGST.ConditionBaseValue      as BaseValue_IGST,
      IGST.ConditionScaleBasisUnit as BaseValueUnit_IGST,
      IGST.ConditionQuantity       as ConditionQuantity_IGST,
      IGST.ConditionQuantityUnit   as QuantityUnit_IGST,
      IGST.ConditionType           as ConditionType_IGST,
      IGST.ConditionCurrency       as ConditionCurrency_IGST,
      IGST.ConditionRateValue      as ConditionRateAmount_IGST,
      IGST.ConditionRateRatioUnit  as ConditionRateunit_IGST,
      @Semantics.amount.currencyCode: 'curky'
      CGST.ConditionAmount         as ConditionAmount_CGST,
      CGST.ConditionBaseValue      as BaseValue_CGST,
      CGST.ConditionScaleBasisUnit as BaseValueUnit_CGST,
      CGST.ConditionQuantity       as ConditionQuantity_CGST,
      CGST.ConditionQuantityUnit   as QuantityUnit_CGST,
      CGST.ConditionType           as ConditionType_CGST,
      CGST.ConditionCurrency       as ConditionCurrency_CGST,
      CGST.ConditionRateValue      as ConditionRateAmount_CGST,
      CGST.ConditionRateRatioUnit  as ConditionRateunit_cGST,
      @Semantics.amount.currencyCode: 'curky'
      SGST.ConditionAmount         as ConditionAmount_SGST,
      SGST.ConditionBaseValue      as BaseValue_SGST,
      SGST.ConditionScaleBasisUnit as BaseValueUnit_SGST,
      SGST.ConditionQuantity       as ConditionQuantity_SGST,
      SGST.ConditionQuantityUnit   as QuantityUnit_SGST,
      SGST.ConditionType           as ConditionType_SGST,
      SGST.ConditionCurrency       as ConditionCurrency_SGST,
      SGST.ConditionRateValue      as ConditionRateAmount_SGST,
      SGST.ConditionRateRatioUnit  as ConditionRateunit_sGST,
      @Semantics.amount.currencyCode: 'curky'
      RoundOff.ConditionAmount     as RoundoffAmount,
      @Semantics.amount.currencyCode: 'curky'
      ZFRI.ConditionAmount         as ConditionAmount_ZFRI,
      ZFRI.ConditionBaseValue      as BaseValue_ZFRI,
      ZFRI.ConditionScaleBasisUnit as BaseValueUnit_ZFRI,
      ZFRI.ConditionQuantity       as ConditionQuantity_ZFRI,
      ZFRI.ConditionQuantityUnit   as QuantityUnit_ZFRI,
      ZFRI.ConditionType           as ConditionType_ZFRI,
      ZFRI.ConditionCurrency       as ConditionCurrency_ZFRI,
      ZFRI.ConditionRateValue      as ConditionRateAmount_ZFRI,
      @Semantics.amount.currencyCode: 'curky'
      tsc.ConditionAmount          as ConditionAmount_tsc,
      tsc.ConditionBaseValue       as BaseValue_tsc,
      tsc.ConditionScaleBasisUnit  as BaseValueUnit_tsc,
      tsc.ConditionQuantity        as ConditionQuantity_tsc,
      tsc.ConditionQuantityUnit    as QuantityUnit_tsc,
      tsc.ConditionType            as ConditionType_tsc,
      tsc.ConditionCurrency        as ConditionCurrency_tsc,
      tsc.ConditionRateValue       as ConditionRateAmount_tsc,
      tsc.ConditionRateRatioUnit   as ConditionRateunit_tsc
}
where
  bdi.BillingDocumentItem >= '000010'

