@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Finals'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP03_prod_final as select from ZAPP02_Prod_AC_FINAL
{
    key CompanyCode,
    key Fiscal_Period,
    key Fiscal_Year,
    key Material,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    sum(Quantity) as Quantity,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum(Total_Amount) as TotalAmount, 
    MaterialBaseUnit,
    CompanyCodeCurrency,
//    ManufacturingOrder,
//    GoodsMovementType,
   sum( ECU_QUANTITY ) as ECU_QUANTITY,
    sum(MTN_QUANTITY) as MTN_QUANTITY,
    sum(NR_QUANTITY) as NR_QUANTITY,
    sum(ECU_AMOUNT) as ECU_AMOUNT,
   sum( MTN_AMOUNT) as MTN_AMOUNT,
    sum(NR_AMOUNT)as NR_AMOUNT,
    QuantityNumerator,
    QuantityDenominator,
    sum(ConversionQuantity) as ConversionQuantity,
//    Product_Quntity,
//    Product_Amount,
   sum( ECU_Per_1000) as ECU_Per_1000,
   sum( MTN_Per_2000) as MTN_Per_2000,
    sum(NR_Per_3000) as NR_Per_3000
}
group by
CompanyCode,
Fiscal_Period,
CompanyCodeCurrency,
Fiscal_Year,
Material,
MaterialBaseUnit,
 QuantityNumerator,
    QuantityDenominator,
    ConversionQuantity
//    Product_Quntity,
//    Product_Amount

