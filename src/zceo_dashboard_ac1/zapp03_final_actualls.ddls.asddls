@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final Actualls'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]

define view entity ZAPP03_FINAL_ACTUALLS as select from ZAPP03_CASHPROFIT

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
    EBITDA_MARGIN_PERCENT,
    TOTAL_COST_OF_PRODUCTION,
    NET_PROFIT,
    
      NET_PROFIT
    + TOTAL_Depreciation
    as TOTAL_COST_PROFIT,
    
    NET_PROFIT
    +TOTAL_Trading_Profit
    as Total_P_B_T
    
}
