@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EBIDTA MARGIN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPPO2_EBIDTA_2 
as select from ZAPP02_EBIDTA


/* USED IN / ZAPP02_NET_PROFIT */

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
    
  cast(  case
    when TOTAL_OTHER_INCOME <> 0
    then ( EBITDA / TOTAL_OTHER_INCOME ) * 100
    else 0
 end
    as abap.dec(15,2)
)as EBITDA_MARGIN_PERCENT,    
    
    
    TOTAL_VARIABLE_COST
+ Total_Fixed_Cost
+ TOTAL_Finance_Charges
+ TOTAL_Depreciation
as TOTAL_COST_OF_PRODUCTION
}
