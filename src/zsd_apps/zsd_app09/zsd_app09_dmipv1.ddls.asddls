@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Domestic Invoices  Items'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_APP09_DMIPV1
  as projection on ZSD_APP09_DMIV1
{
  key ccode,
  key billdoc,
  key billitm,
      product,
      @Semantics.quantity.unitOfMeasure: 'unit'
      billqty,
      unit,
      @Semantics.amount.currencyCode: 'curky'
      netamt,
      curky,
      hsnno,
      Itemtxt,
      Batch,
      Plant,
      Matdesc,
      RateUnit,
      @Semantics.amount.currencyCode: 'curky'
      ConditionAmount_zpro,
      BaseValue_zpro,
      BaseValueUnit_zpro,
      ConditionQuantity_zpro,
      QuantityUnit_zpro,
      ConditionType_zpro,
      ConditionCurrency_zpro,
      ConditionRateAmount_zpro,
      @Semantics.amount.currencyCode: 'curky'
      ConditionAmount_igst,
      BaseValue_igst,
      BaseValueUnit_igst,
      ConditionQuantity_igst,
      QuantityUnit_igst,
      ConditionType_igst,
      ConditionCurrency_igst,
      ConditionRateAmount_igst,
      ConditionRateunit_igst,
      @Semantics.amount.currencyCode: 'curky'
      ConditionAmount_cgst,
      BaseValue_cgst,
      BaseValueUnit_cgst,
      ConditionQuantity_cgst,
      QuantityUnit_cgst,
      ConditionType_cgst,
      ConditionCurrency_cgst,
      ConditionRateAmount_cgst,
      ConditionRateunit_cgst,
      @Semantics.amount.currencyCode: 'curky'
      ConditionAmount_sgst,
      BaseValue_sgst,
      BaseValueUnit_sgst,
      ConditionQuantity_sgst,
      QuantityUnit_sgst,
      ConditionType_sgst,
      ConditionCurrency_sgst,
      ConditionRateAmount_sgst,
      ConditionRateunit_sgst,
      @Semantics.amount.currencyCode: 'curky'
      ConditionAmount_tsc,
      BaseValue_tsc,
      BaseValueUnit_tsc,
      ConditionQuantity_tsc,
      QuantityUnit_tsc,
      ConditionType_tsc,
      ConditionCurrency_tsc,
      ConditionRateAmount_tsc,
      @Semantics.amount.currencyCode: 'curky'
      RoundoffAmount,
      @Semantics.amount.currencyCode: 'curky'
      ConditionAmount_zfri,
      BaseValue_zfri,
      BaseValueUnit_zfri,
      ConditionQuantity_zfri,
      QuantityUnit_zfri,
      ConditionType_zfri,
      ConditionCurrency_zfri,
      /* Associations */
      _Header : redirected to parent ZSD_APP09_DMRPV
}
