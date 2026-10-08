@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contribution'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_Contribution
   as select from ZAPP02_OTHER_INCOME
{
    key CompanyCode,
    key Fiscal_Period,
    key Fiscal_Year,
    key TransactionCurrency,
    key Product,
    key GLAccount,

    OTHER_INCOME,
    Raw_Materials,
    FG_WIPCost,
    PowerCost,
    FuelCost,
    StoresConsumableCost,
    LabourCost,
    Depreciation,
    Employees_R_B,
    R_M_Machinery,
    Insurance,
    Travelling_Expenses,
    Miscellaneous_Expenses,
    Director_Remuneration,
    Frt_ED_paid,
    Auditors_Remuneration,
    Finance_Charges,
    Trading_Profit,
    Fixed_Cost,
    TotalVariableCost,

    // Total Fixed Cost = Contribution - Fixed Cost
    
    cast(
        (
            OTHER_INCOME - TotalVariableCost
        ) - Fixed_Cost
        as abap.dec(23,2)
    ) as TotalFixedCost,

cast(
    OTHER_INCOME - TotalVariableCost
    as abap.dec(23,2)
) as Contribution,

// Contribution Margin % = Other Income / Contribution * 100
case
    when ( OTHER_INCOME - TotalVariableCost ) <> 0
    then cast(
        ( OTHER_INCOME * 100 )
        / ( OTHER_INCOME - TotalVariableCost )
        as abap.dec(23,2)
    )
    else cast(
        0
        as abap.dec(23,2)
    )
end as ContributionMarginPercent


}





















//define view entity ZAPP02_Contribution as select from  ZAPP02_OTHER_INCOME
//{
//    key CompanyCode,
//    key Fiscal_Period,
//    key Fiscal_Year,
//    key TransactionCurrency,
//    key Product,
//    key GLAccount,
//    OTHER_INCOME,
//    Raw_Materials,
//    FG_WIPCost,
//    PowerCost,
//    FuelCost,
//    StoresConsumableCost,
//    LabourCost,
//    Depreciation,  
//    Employees_R_B,
//    R_M_Machinery,
//    Insurance,
//    Travelling_Expenses,
//     Miscellaneous_Expenses,
//     Director_Remuneration,
//     Frt_ED_paid,
//     Auditors_Remuneration, 
//    Fixed_Cost,
//    TotalVariableCost,
//
//    cast( OTHER_INCOME - TotalVariableCost as abap.dec(23,2) ) 
//         as Contribution, 
//         case when OTHER_INCOME <> 0 
//    then 
//    
//     cast( ( ( OTHER_INCOME - TotalVariableCost ) * 100 ) / OTHER_INCOME as abap.dec(23,2) ) 
//      else 
//       cast( 0 as abap.dec(23,2) )
//          end as ContributionMarginPercent   
//          
//      }
      
      
      
