@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FINANCIAL DASHBOARD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
define view entity ZAPP02_FINANCIAL_DASHBOARD as select from ZAPP02_Contribution
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
    TotalVariableCost,
    Fixed_Cost,
    Trading_Profit,
    Contribution,
    ContributionMarginPercent,

    // Total Fixed Cost = Contribution - Fixed Cost
    cast(
        Contribution - Fixed_Cost
        as abap.dec(23,2)
    ) as TotalFixedCost,

    // EBITDA = Contribution - Total Fixed Cost
    cast(
        Contribution
        - ( Contribution - Fixed_Cost )
        as abap.dec(23,2)
    ) as EBIDTA,
    
    case
    when (
        Contribution - ( Contribution - Fixed_Cost )
    ) <> 0
    then cast(
        ( OTHER_INCOME * 100 )
        / ( Contribution - ( Contribution - Fixed_Cost ) )
        as abap.dec(23,2)
    )
    else cast(
        0 as abap.dec(23,2)
    )
end as EBIDTAMarginPercent,

    // Total Cost of Production
    
    cast(
        Depreciation
        + Finance_Charges
        + Fixed_Cost
        + TotalVariableCost
        as abap.dec(23,2)
    ) as TotalCostOfProduction,
    
        // Net Profit = Total Income - Total Cost of Production
        
    cast(
        OTHER_INCOME
        - (
            Depreciation
            + Finance_Charges
            + Fixed_Cost
            + TotalVariableCost
        )
        as abap.dec(23,2)
    ) as NetProfit,
    
        // PBT = Trading Profit + Net Profit
    
    cast(
        Trading_Profit
        +
        (
            OTHER_INCOME
            - (
                Depreciation
                + Finance_Charges
                + Fixed_Cost
                + TotalVariableCost
            )
        )
        as abap.dec(23,2)
    ) as PBT,
    
        // Cash Profit = Net Profit + Depreciation
    cast(
        (
            OTHER_INCOME
            - (
                Depreciation
                + Finance_Charges
                + Fixed_Cost
                + TotalVariableCost
            )
        )
        + Depreciation
        as abap.dec(23,2)
    ) as CashProfit
    
}
