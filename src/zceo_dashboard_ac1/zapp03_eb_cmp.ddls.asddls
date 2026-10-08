@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EBTIDA Contribution margin Percent'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP03_EB_CMP as select from ZAAP03_CONTRIBUTION

      /* 5th CDS
               USED IN ------------   ZAPP03_EMP_TCOP    */
  
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

    
    TOTAL_CONTRIBUTION
     - Total_Fixed_Cost
    as EBITDA, 
 
    case
        when TOTAL_OTHER_INCOME <> 0
        then ( TOTAL_CONTRIBUTION / TOTAL_OTHER_INCOME ) * 100
        else 0
    end as CONTRIBUTION_MARGIN_PERCENT
    
}
