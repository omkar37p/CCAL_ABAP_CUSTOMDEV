@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'NET PROFIT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_NET_PROFIT
 as select from ZAPPO2_EBIDTA_2
  
/* USED IN / ZAPP02_CASH_PROFIT */
 
{
    key CompanyCode,
    key Fiscal_Year,
    key Fiscal_Period,
    key TransactionCurrency,
    TOTAL_RAW_MATERIALS,
    TOTAL_FG_WIP,
    TOTAL_POWER,
    TOTAL_FUEL,
    TOTAL_LABOUR,
    TOTAL_Depreciation,
    TOTAL_OTHER_INCOME,
    TOTAL_VARIABLE_COST,
    CONTRIBUTION,
    TOTAL_Employees_R_B,
    TOTAL_R_M_Machinery,
    TOTAL_Insurance,
    TOTAL_Trvelling_Expenses,
    TOTAL_Miscellaneous_Expe,
    TOTAL_Director_Rem,
    TOTAL_Auditors_Rem,
    TOTAL_Finance_Charges,
    TOTAL_Trading_Profit,
    Total_Fixed_Cost,
    EBITDA,
    CONTRIBUTION_MARGIN_PERCENT,
    EBITDA_MARGIN_PERCENT,
    TOTAL_COST_OF_PRODUCTION,
    
    TOTAL_OTHER_INCOME
    - TOTAL_COST_OF_PRODUCTION
    as NET_PROFIT
    
}
