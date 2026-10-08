@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Actuals'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP03_SALES_AC as select from ZAPP02_SALES_Actuals_AGG
{

 key CompanyCode,
 key Fiscal_Period,
 key Fiscal_Year,
 key Product,
  BillingDocumentType,
 ProductDescription,
 @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
 sum(BillingQuantity)  as Sales_Quantity,
 BillingQuantityUnit,
 BaseUnit,
 QuantityNumerator,
 QuantityDenominator,
 
 division(
            cast(
                QuantityNumerator
                as abap.dec(15,5)
            ),
            cast(
                QuantityDenominator
                as abap.dec(15,5)
            ),
            5
        ) as ConversionQuantity,
 
 sum( ECU) as ECU_QUANTITY,
 sum( MTN) as MTN_QUANTITY,
 sum( NR) as NR_QUANTITY,
 sum( ECU_AMOUNT) as ECU_AMOUNT,
 sum( MTN_Amount) as MTN_AMOUNT,
 sum( NR_Amount) as NR_AMOUNT,

 TransactionCurrency
 
}
group by
CompanyCode,
    Fiscal_Period,
    Fiscal_Year,
    Product,
     BillingDocumentType,
    BillingQuantityUnit, 
    BaseUnit,
    TransactionCurrency,
     ProductDescription,
    ECU,
    MTN,
    NR,
    ECU_AMOUNT,
    MTN_Amount,
    NR_Amount,
    QuantityNumerator,
    QuantityDenominator;
