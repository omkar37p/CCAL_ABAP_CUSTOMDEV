@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Variable & Fixed Cost Calculation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP03_VR_FX_C as select from ZAPP03_GL_SUM

      /*  3rd CDS 
                 USED IN -----   ZAAP03_CONTRIBUTION    */
  
{
//    key CompanyCode,
    key Fiscal_YEAR,
    key Fiscal_Period,
//    key CompanyCodeCurrency,
    
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
    TOTAL_Frt_ED_paid,
    TOTAL_Finance_Charges,
    TOTAL_Trading_Profit,
    
    TOTAL_RAW_MATERIALS
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
    +TOTAL_Frt_ED_paid
//    +TOTAL_Finance_Charges
//    +TOTAL_Trading_Profit
    as Total_Fixed_Cost
    
}
 