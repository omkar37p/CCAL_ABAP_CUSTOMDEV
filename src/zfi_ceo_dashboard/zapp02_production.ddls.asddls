@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
define view entity ZAPP02_PRODUCTION
  as select from ZAPP01_PROD_PERIOD

{
    key CompanyCode,
        PostingDate,
        Fiscal_Period,
        Fiscal_Year,
        Material,

        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        @Aggregation.default: #SUM
        sum( GoodsIssueQtyInBaseUnit ) as Quantity,

        MaterialBaseUnit,

        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        @Aggregation.default: #SUM
        sum( ConversionQuantity ) as TotalConversionQuantity

}
group by

    CompanyCode,
    PostingDate,
    Fiscal_Period,
    Fiscal_Year,
    Material,
    MaterialBaseUnit;











//{
//       key CompanyCode,
//           Fiscal_Period,
//           Fiscal_Year,
//           Material,
//
//         @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//        sum( GoodsIssueQtyInBaseUnit ) as quantity,
//
//        MaterialBaseUnit
//
//}
//group by
//CompanyCode,
//Fiscal_Period,
//Fiscal_Year,
//Material,
//MaterialBaseUnit












// as select from ZAPP01_PROD_PERIOD
//{
//    key CompanyCode,
//        MfgOrderActualCompletionDate as MfgOrderActualCompletionDate,
//
//        substring( MfgOrderActualCompletionDate, 5, 2 ) as Fiscal_Period,
//        substring( MfgOrderActualCompletionDate, 1, 4 ) as Fiscal_Year,
//
//        Product,
//        @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
//        @Aggregation.default: #SUM
//        sum( Quantity ) as Quantity,
//        ProductionUnit
//
//}
//group by
//CompanyCode,
//MfgOrderActualCompletionDate,
//Fiscal_Period,
//Fiscal_Year,
//Product,
//ProductionUnit



    
