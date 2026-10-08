@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Actuals Final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_SALES_AC__FINAL as select from ZAPP03_SALES_AC
{
    key CompanyCode,
    key Fiscal_Period,
    key Fiscal_Year,
    key Product,
    BillingDocumentType,
    ProductDescription,
    @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
    Sales_Quantity,
    BillingQuantityUnit,
    BaseUnit,
    QuantityNumerator,
    QuantityDenominator,
    ConversionQuantity,
    ECU_QUANTITY,
    MTN_QUANTITY,
    NR_QUANTITY,
    ECU_AMOUNT,
    MTN_AMOUNT,
    NR_AMOUNT,
    TransactionCurrency,
    
    division(
    cast( ECU_AMOUNT as abap.dec(15,5) ),
    cast( ConversionQuantity as abap.dec(15,5) ),
    5
) * 1000 as ECU_Per_1000,

division(
    cast( MTN_AMOUNT as abap.dec(15,5) ),
    cast( ConversionQuantity as abap.dec(15,5) ),
    5
) * 1000 as MTN_Per_2000,

division(
    cast( NR_AMOUNT as abap.dec(15,5) ),
    cast( ConversionQuantity as abap.dec(15,5) ),
    5
) * 1000 as NR_Per_3000
}


