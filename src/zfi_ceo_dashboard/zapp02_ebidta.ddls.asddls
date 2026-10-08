@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EBIDTA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_EBIDTA 
  as select from ZAPP02_CONTB_2
  
  
/* USED IN / ZAPP02_EBIDTA_2 */
  
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

    
    CONTRIBUTION
     - Total_Fixed_Cost
    as EBITDA, 
 
    case
        when TOTAL_OTHER_INCOME <> 0
        then ( CONTRIBUTION / TOTAL_OTHER_INCOME ) * 100
        else 0
    end as CONTRIBUTION_MARGIN_PERCENT
    
}



//  as select from ZAPP02_Contribution
//{
//    key CompanyCode,
//    key Fiscal_Period,
//    key Fiscal_Year,
//    key TransactionCurrency,
//    key Product,
//    key GLAccount,
//
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
//    Miscellaneous_Expenses,
//    Director_Remuneration,
//    Frt_ED_paid,
//    Auditors_Remuneration,
//    Finance_Charges,
//    TotalVariableCost,
//    Fixed_Cost,
//    Trading_Profit,
//    Contribution,
//    ContributionMarginPercent,
//
//    // Total Fixed Cost = Contribution - Fixed Cost
//    
//    cast(
//        Contribution - Fixed_Cost
//        as abap.dec(23,2)
//    ) as TotalFixedCost,
//
//    // EBITDA = Contribution - Total Fixed Cost
//    
//    cast(
//        Contribution
//        - ( Contribution - Fixed_Cost )
//        as abap.dec(23,2)
//    ) as EBIDTA,
//    
//    case
//    when (
//        Contribution - ( Contribution - Fixed_Cost )
//    ) <> 0
//    then cast(
//        ( OTHER_INCOME * 100 )
//        / ( Contribution - ( Contribution - Fixed_Cost ) )
//        as abap.dec(23,2)
//    )
//    else cast(
//        0 as abap.dec(23,2)
//    )
//end as EBIDTAMarginPercent,
//
//    // Total Cost of Production
//    
//    cast(
//        Depreciation
//        + Finance_Charges
//        + Fixed_Cost
//        + TotalVariableCost
//        as abap.dec(23,2)
//    ) as TotalCostOfProduction,
//    
//        // Net Profit = Total Income - Total Cost of Production
//        
//    cast(
//        OTHER_INCOME
//        - (
//            Depreciation
//            + Finance_Charges
//            + Fixed_Cost
//            + TotalVariableCost
//        )
//        as abap.dec(23,2)
//    ) as NetProfit,
//    
//    // PBT = Trading Profit + Net Profit
//    
//    cast(
//        Trading_Profit
//        +
//        (
//            OTHER_INCOME
//            - (
//                Depreciation
//                + Finance_Charges
//                + Fixed_Cost
//                + TotalVariableCost
//            )
//        )
//        as abap.dec(23,2)
//    ) as PBT,
//    
//        // Cash Profit = Net Profit + Depreciation
//        
//    cast(
//        (
//            OTHER_INCOME
//            - (
//                Depreciation
//                + Finance_Charges
//                + Fixed_Cost
//                + TotalVariableCost
//            )
//        )
//        + Depreciation
//        as abap.dec(23,2)
//    ) as CashProfit
//    
//}
