@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EBTIDA Percent & Total Cost of Product'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP03_EMP_TCOP as select from ZAPP03_EB_CMP

      /*    6th CDS
                   USED IN -------------  ZAPP03_NETPROFIT      */

{
//    key CompanyCode,
    key Fiscal_YEAR,
    key Fiscal_Period,
//    key CompanyCodeCurrency,
    TOTAL_RAW_MATERIALS,
    TOTAL_FG_WIP,
    TOTAL_POWER,
    TOTAL_FUEL, 
    TOTAL_LABOUR, 
    TOTAL_Depreciation,
    TOTAL_OTHER_INCOME,
    TOTAL_VARIABLE_COST,
    TOTAL_CONTRIBUTION, 
    TOTAL_Employees_R_B,
    TOTAL_R_M_Machinery,
    TOTAL_Insurance,
    TOTAL_Trvelling_Expenses,
    TOTAL_Miscellaneous_Expe,
    TOTAL_Director_Rem,
    TOTAL_Auditors_Rem,
    TOTAL_Finance_Charges,
    TOTAL_Frt_ED_paid,
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

