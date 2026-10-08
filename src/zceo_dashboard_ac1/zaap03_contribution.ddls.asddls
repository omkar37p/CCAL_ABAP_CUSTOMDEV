@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contribution Calulation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAAP03_CONTRIBUTION as select from ZAPP03_VR_FX_C

             /*   4th CDS
                         USED IN  ------------  ZAPP03_EB_CMP */

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

    TOTAL_OTHER_INCOME
    - TOTAL_VARIABLE_COST
    as TOTAL_CONTRIBUTION
}
