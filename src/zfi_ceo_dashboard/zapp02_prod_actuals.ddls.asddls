@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Actuals'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_Prod_Actuals
    as select from ZAPP02_Prod_AGG
{
    key CompanyCode,
    key Fiscal_Period,
    key Fiscal_Year,
    key Material,

    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    @Aggregation.default: #SUM
    sum( GoodsReceiptQtyInBaseUnit ) as Quantity,

    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    @Aggregation.default: #SUM
    sum( GoodsReceiptAmountInCoCodeCrcy ) as Total_Amount,

    MaterialBaseUnit,
    CompanyCodeCurrency,
    ManufacturingOrder,
    GoodsMovementType,

  sum( ECU) as ECU_QUANTITY,
 sum( MTN) as MTN_QUANTITY,
 sum( NR) as NR_QUANTITY,
 sum( ECU_AMOUNT) as ECU_AMOUNT,
 sum( MTN_AMOUNT) as MTN_AMOUNT,
 sum( NR_AMOUNT) as NR_AMOUNT,
  
    QuantityNumerator,
    QuantityDenominator,

    division(
        cast(
            QuantityNumerator as abap.dec(15,5)
        ),
        cast(
            QuantityDenominator as abap.dec(15,5)
        ),
        5
    ) as ConversionQuantity,
    
    ECU
    + MTN
    + NR
    as Product_Quntity,
    
    ECU_AMOUNT
    + MTN_AMOUNT
    + NR_AMOUNT
    as Product_Amount
    
    
    
}
group by
    CompanyCode,
    Fiscal_Period,
    Fiscal_Year,
    Material,
    MaterialBaseUnit,
    CompanyCodeCurrency,
    QuantityNumerator,
    ECU,
    MTN,
    NR,
    ECU_AMOUNT,
    MTN_AMOUNT,
    NR_AMOUNT,
    ManufacturingOrder,
    GoodsMovementType,
    QuantityDenominator;


