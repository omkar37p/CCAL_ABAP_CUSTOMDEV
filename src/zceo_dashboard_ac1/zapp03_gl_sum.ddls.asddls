@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SUM of all GLs'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP03_GL_SUM as select from ZAPP03_GL_LIST
  
    /*  2nd CDS
                USED IN  ----   ZAPP03_VR_FX_C    */
    
{
      
//    key CompanyCode,
    key Fiscal_YEAR,
    key Fiscal_Period,
//    key CompanyCodeCurrency,
      
    sum( OTHER_INCOME)           as TOTAL_OTHER_INCOME,
    sum( Raw_Materials )         as TOTAL_RAW_MATERIALS,
    sum( FG_WIP )                as TOTAL_FG_WIP,
    sum( POWER )                 as TOTAL_POWER,
    sum( FUEL )                  as TOTAL_FUEL,
    sum( LABOUR )                as TOTAL_LABOUR,
    sum(Stores_Consumables)      as TOTAL_Stores_Consumables,
    sum( Depreciation )          as TOTAL_Depreciation,
    sum( Employees_R_B )         as TOTAL_Employees_R_B,
    sum( R_M_Machinery )         as TOTAL_R_M_Machinery,
    sum(R_M_Buildings)           as TOTAL_R_M_Buildings,
    sum( Insurance )             as TOTAL_Insurance,
    sum(Frt_ED_paid)             as TOTAL_Frt_ED_paid,
    sum( Trvelling_Expenses )    as TOTAL_Trvelling_Expenses,
    sum( Miscellaneous_Expe )    as TOTAL_Miscellaneous_Expe,
    sum( Director_Rem )          as TOTAL_Director_Rem,
    sum( Auditors_Rem )          as TOTAL_Auditors_Rem,
    sum( Finance_Charges )       as TOTAL_Finance_Charges,
    sum( Trading_Profit )        as TOTAL_Trading_Profit

}
group by
//    CompanyCode,
    Fiscal_YEAR,
    Fiscal_Period
//     CompanyCodeCurrency
     
     
     
