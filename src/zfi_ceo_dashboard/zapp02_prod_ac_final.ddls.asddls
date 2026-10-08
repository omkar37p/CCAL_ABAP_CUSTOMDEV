@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Actuals Final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
define view entity ZAPP02_Prod_AC_FINAL as select from ZAPP02_Prod_Actuals
{
 key CompanyCode,
key Fiscal_Period,
key Fiscal_Year,
key Material,

@Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
Quantity,

@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
Total_Amount,

MaterialBaseUnit,
CompanyCodeCurrency,
ManufacturingOrder,
GoodsMovementType,

ECU_QUANTITY,
MTN_QUANTITY,
NR_QUANTITY,

ECU_AMOUNT,
MTN_AMOUNT,
NR_AMOUNT,

QuantityNumerator,
QuantityDenominator,

ConversionQuantity,
Product_Quntity,
Product_Amount,

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
//where
//GoodsMovementType = '101'
//or GoodsMovementType = '102'
//or ManufacturingOrder <> ''
