@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
define view entity ZAPP02_SALES
  as select from ZAPP01_SALES_PERIOD
{
    key CompanyCode,
        BillingDate,
        Fiscal_Period,
        Fiscal_Year,
        BillingDocumentType,
        Product,
        SalesCategory,

        @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
        @Aggregation.default: #SUM
        sum( BillingQuantity ) as TotalQuantity,

        BillingQuantityUnit,
        
        @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
        @Aggregation.default: #SUM
        sum( ConversionQuantity ) as TotalConversionQuantity,

        @Semantics.amount.currencyCode: 'TransactionCurrency'
        @Aggregation.default: #SUM
        sum( NetAmount ) as TotalAmount,

        TransactionCurrency,

case
    when SalesCategory = 'ECU'
         and sum( ConversionQuantity ) <> 0
    then
        division(
            cast( sum( NetAmount ) as abap.dec(23,2) ),
            cast( sum( ConversionQuantity ) as abap.dec(23,5) ),
            2
        )
    else 0
end as ECU_SaleValue_Per_Quantity,

        case
    when SalesCategory = 'MTN'
         and sum( ConversionQuantity ) <> 0
    then
        division(
            cast( sum( NetAmount ) as abap.dec(23,2) ),
            cast( sum( ConversionQuantity ) as abap.dec(23,5) ),
            2
        )
    else 0
end as MTN_SaleValue_Per_Quantity,

       case
    when SalesCategory = 'NR'
         and sum( ConversionQuantity ) <> 0
    then
        division(
            cast( sum( NetAmount ) as abap.dec(23,2) ),
            cast( sum( ConversionQuantity ) as abap.dec(23,5) ),
            2
        )
    else 0
end as NR_SaleValue_Per_Quantity

}
group by

    CompanyCode, 
    BillingDate,
    Fiscal_Period,
    Fiscal_Year,
    BillingDocumentType,
    Product,
    SalesCategory,
    BillingQuantityUnit,
    BaseUnit,
    TransactionCurrency;







//define view entity ZAPP02_SALES
//  as select from ZAPP01_SALES_period
//{   
//    key CompanyCode,
//     Fiscal_Period,
//     Fiscal_Year,
//
//    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
//    @Aggregation.default: #SUM
//    sum( BillingQuantity ) as TotalQuantity,
//
//    BillingQuantityUnit,
//    BaseUnit,
////    Product,
//    @Semantics.amount.currencyCode: 'TransactionCurrency'
//    @Aggregation.default: #SUM
//    sum( NetAmount ) as TotalAmount,
//
//    TransactionCurrency
//}
//group by
//    CompanyCode,
//    Fiscal_Period,
//    Fiscal_Year,
//    BillingQuantityUnit,
//    BaseUnit,
////    Product,
//    TransactionCurrency;





