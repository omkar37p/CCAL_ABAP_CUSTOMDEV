@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Periods'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP01_SALES_AGG
  as select from ZAPP01_MANUFACTUIRNG
  
  /* USED IN / ZAPP02_CONTB_2 */
  
{
    key CompanyCode,
    key Fiscal_YEAR,
    key Fiscal_Period,

    
    key TransactionCurrency,
    TOTAL_OTHER_INCOME,
    TOTAL_RAW_MATERIALS,
    TOTAL_FG_WIP,
    TOTAL_POWER,
    TOTAL_FUEL,
    TOTAL_LABOUR,
    TOTAL_Depreciation,
    TOTAL_Employees_R_B,
    TOTAL_R_M_Machinery,
    TOTAL_Insurance,
    TOTAL_Trvelling_Expenses,
    TOTAL_Miscellaneous_Expe,
    TOTAL_Director_Rem,
    TOTAL_Auditors_Rem,
    TOTAL_Finance_Charges,
    TOTAL_Trading_Profit,
    
    TOTAL_RAW_MATERIALS
//    +TOTAL_OTHER_INCOME
    + TOTAL_FG_WIP
    + TOTAL_POWER
    + TOTAL_FUEL
    + TOTAL_LABOUR
    + TOTAL_Stores_Consumables
    as TOTAL_VARIABLE_COST,
    
    TOTAL_Employees_R_B
    +TOTAL_R_M_Machinery
    +TOTAL_R_M_Buildings
    +TOTAL_Insurance
    +TOTAL_Trvelling_Expenses
    +TOTAL_Miscellaneous_Expe
    +TOTAL_Director_Rem
    +TOTAL_Auditors_Rem
    +TOTAL_Finance_Charges
    +TOTAL_Trading_Profit
    as Total_Fixed_Cost
    
}
 

//  as select from ZAPP01_SALES_period
//{
//    key BillingDocument,
//    Fiscal_Period,
//    Fiscal_Year,
//
//    @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
//    @Aggregation.default: #SUM
//    sum( BillingQuantity ) as TotalQuantity,
//
//    BillingQuantityUnit,
//
//    @Semantics.amount.currencyCode: 'TransactionCurrency'
//    @Aggregation.default: #SUM
//    sum( NetAmount ) as TotalAmount,
//
//    TransactionCurrency
//}
//group by
//    BillingDocument,
//    Fiscal_Period,
//    Fiscal_Year,
//    BillingQuantityUnit,
//    TransactionCurrency;









//define view entity ZAPP01_SALES_AGG
//  as select from ZAPP01_BILLING
//{
//    key CompanyCode,
//    key BillingQuantityUnit,
//
//    @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
//    sum( BillingQuantity ) as SalesQuantity,
//
//    @Semantics.amount.currencyCode: 'TransactionCurrency'
//    sum( NetAmount ) as Revenue,
//
//    TransactionCurrency
//}
//where CompanyCode = '1000'
//group by
//
//    CompanyCode,
//    BillingQuantityUnit,
//    TransactionCurrency
