@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SALES FINAL 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_SALES_F as select from ZAPP02_SALES_AC__FINAL
{
    key CompanyCode,
    key Fiscal_Period,
    key Fiscal_Year,
    key Product,
//    BillingDocumentType,
    ProductDescription,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
   sum( Sales_Quantity) as SALES_QUANTITY,
//    BillingQuantityUnit,
    BaseUnit,
    QuantityNumerator,
    QuantityDenominator,
   sum( ConversionQuantity ) as ConversionQuantity,
   sum( ECU_QUANTITY ) as ECU_QUANTITY,
    sum(MTN_QUANTITY) as TN_QUANTITY,
    sum(NR_QUANTITY) as NR_QUANTITY,
    sum(ECU_AMOUNT) as ECU_AMOUNT,
    sum(MTN_AMOUNT) as MTN_AMOUNT,
    sum( NR_AMOUNT) as NR_AMOUNT,
    TransactionCurrency,
    sum(ECU_Per_1000) as ECU_Per_1000,
   sum( MTN_Per_2000 ) as MTN_Per_2000,
    sum(NR_Per_3000) as NR_Per_3000
}

group by
CompanyCode,
Fiscal_Period,
Fiscal_Year,
Product,
BillingDocumentType,
ProductDescription,
Sales_Quantity,
BillingQuantityUnit,
    BaseUnit,
    QuantityNumerator,
    QuantityDenominator,
    TransactionCurrency





