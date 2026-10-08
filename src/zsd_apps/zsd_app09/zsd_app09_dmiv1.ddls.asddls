@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Domestic Invoices  Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_APP09_DMIV1
  as select from ZFDP_DMINV02
  association to parent ZSD_APP09_DMRV as _Header on  $projection.ccode   = _Header.ccode
                                                  and $projection.billdoc = _Header.billdoc
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
      Matdesc,
      Batch,
      Plant,
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
      ConditionAmount_IGST,
      BaseValue_IGST,
      BaseValueUnit_IGST,
      ConditionQuantity_IGST,
      QuantityUnit_IGST,
      ConditionType_IGST,
      ConditionCurrency_IGST,
      ConditionRateAmount_IGST,
      ConditionRateunit_IGST,
      @Semantics.amount.currencyCode: 'curky'
      ConditionAmount_CGST,
      BaseValue_CGST,
      BaseValueUnit_CGST,
      ConditionQuantity_CGST,
      QuantityUnit_CGST,
      ConditionType_CGST,
      ConditionCurrency_CGST,
      ConditionRateAmount_CGST,
      ConditionRateunit_cGST,
      @Semantics.amount.currencyCode: 'curky'
      ConditionAmount_SGST,
      BaseValue_SGST,
      BaseValueUnit_SGST,
      ConditionQuantity_SGST,
      QuantityUnit_SGST,
      ConditionType_SGST,
      ConditionCurrency_SGST,
      ConditionRateAmount_SGST,
      ConditionRateunit_sGST,
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
      ConditionAmount_ZFRI,
      BaseValue_ZFRI,
      BaseValueUnit_ZFRI,
      ConditionQuantity_ZFRI,
      QuantityUnit_ZFRI,
      ConditionType_ZFRI,
      ConditionCurrency_ZFRI,
      _Header
}
