@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MANUFACTURIN ORDER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP01_MANUFACTUIRNG 
  as select from ZAPP01_BILLING
  
  /* USED IN / ZAPP01_SALES_AGG */
  
{
    key CompanyCode,
    key Fiscal_YEAR,
    key Fiscal_Period,
    key TransactionCurrency,

    

    
    sum( OTHER_INCOME) as TOTAL_OTHER_INCOME,
    sum( Raw_Materials ) as TOTAL_RAW_MATERIALS,
    sum( FG_WIP )        as TOTAL_FG_WIP,
    sum( POWER )         as TOTAL_POWER,
    sum( FUEL )          as TOTAL_FUEL,
    sum( LABOUR )        as TOTAL_LABOUR,
    sum(Stores_Consumables) as TOTAL_Stores_Consumables,
    sum( Depreciation )        as TOTAL_Depreciation,
    sum( Employees_R_B )        as TOTAL_Employees_R_B,
    sum( R_M_Machinery )        as TOTAL_R_M_Machinery,
    sum(R_M_Buildings)          as TOTAL_R_M_Buildings,
    sum( Insurance )        as TOTAL_Insurance,
    sum( Trvelling_Expenses )        as TOTAL_Trvelling_Expenses,
    sum( Miscellaneous_Expe )        as TOTAL_Miscellaneous_Expe,
    sum( Director_Rem )        as TOTAL_Director_Rem,
    sum( Auditors_Rem )        as TOTAL_Auditors_Rem,
    sum( Finance_Charges )        as TOTAL_Finance_Charges,
    sum( Trading_Profit )        as TOTAL_Trading_Profit

}
group by
    CompanyCode,
    Fiscal_YEAR,
    Fiscal_Period,
    TransactionCurrency


    
    
    
    
////I_ManufacturingOrder
//ZAPP02_SALES as A
//left outer join ZAPP02_PRODUCTION as B 
//                                     on B.CompanyCode = A.CompanyCode
//                                     and B.Fiscal_Period = A.Fiscal_Period
//                                     and B.Fiscal_Year   = A.Fiscal_Year
//                                     and B.Material      = A.Product
//                                     and B.MaterialBaseUnit  = A.BillingQuantityUnit
//{
//
//   key A.CompanyCode,
//   key    A.Fiscal_Period,
//   key    A.Fiscal_Year,
//   key    A.Product,
//   key    A.BillingQuantityUnit,
//            @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
//       A.TotalQuantity,
//       @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
//       A.TotalConversionQuantity,
//       A.TransactionCurrency,
//       @Semantics.amount.currencyCode: 'TransactionCurrency'
//       A.TotalAmount,
//       A.ECU_SaleValue_Per_Quantity,
//       A.MTN_SaleValue_Per_Quantity,
//       A.NR_SaleValue_Per_Quantity,
//       B.MaterialBaseUnit,
//       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//       B.Quantity,
//       B.TotalConversionQuantity as PROD_CONV_QUTY
        
       


//
//    key ManufacturingOrder,
//    key ManufacturingOrderItem,
//
//    CompanyCode,
//    Material,
//
//    MfgOrderActualCompletionDate,
//
//    @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
//    ActualDeliveredQuantity,
//
//    ProductionUnit

