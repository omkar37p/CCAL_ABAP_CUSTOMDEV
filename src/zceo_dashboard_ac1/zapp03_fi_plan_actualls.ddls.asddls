@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Connection of Plan and Actuals'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP03_FI_PLAN_ACTUALLS 
 as select from ZAPP03_FINAL_ACTUALLS as A 
 left outer join ZAPP03_FI_PLAN as P on P.fiscal_year = A.Fiscal_YEAR
                          and P.fiscal_period   = A.Fiscal_Period
{
 key A.Fiscal_Period as Actual_Fiscal_Period,
 key A.Fiscal_YEAR  as Actual_fiscal_year,
A.TOTAL_RAW_MATERIALS       as Actual_Raw_Materials,
A.TOTAL_FG_WIP              as Actual_FG_WIP,
A.TOTAL_POWER               as Actual_Power,
A.TOTAL_FUEL                as Actual_Fuel,
A.TOTAL_LABOUR              as Actual_Labour,
A.TOTAL_Depreciation        as Actual_Depreciation,
A.TOTAL_OTHER_INCOME        as Actual_Other_Income,
A.TOTAL_VARIABLE_COST       as Actual_Variable_Cost,
A.TOTAL_CONTRIBUTION        as Actual_Contribution,
A.TOTAL_Employees_R_B       as Actual_Employees_R_B,
A.TOTAL_R_M_Machinery       as Actual_R_M_Machinery,
A.TOTAL_Insurance           as Actual_Insurance,
A.TOTAL_Trvelling_Expenses  as Actual_Trvelling_Expenses,
A.TOTAL_Miscellaneous_Expe   as Actual_Miscellaneous_Exp,
A.TOTAL_Director_Rem        as Actual_Director_Rem,
A.TOTAL_Auditors_Rem        as Actual_Auditors_Rem,
A.TOTAL_Finance_Charges     as Actual_Finance_Charges,
A.TOTAL_Frt_ED_paid         as Actual_Frt_ED_paid,
A.TOTAL_Trading_Profit      as Actual_Trading_Profit,
A.Total_Fixed_Cost          as Actual_Fixed_Cost,
A.EBITDA                    as Actual_EBITDA,
A.CONTRIBUTION_MARGIN_PERCENT as Actual_Contribution_Percent,
A.EBITDA_MARGIN_PERCENT     as Actual_EBITDA_Margin_Percent,
A.TOTAL_COST_OF_PRODUCTION  as Actual_Cost_of_Production,
A.NET_PROFIT                as Actual_Net_Profit,
A.TOTAL_COST_PROFIT         as Actual_Cost_PROFIT,
A.Total_P_B_T               as Actual_p_b_T,

P.fiscal_period                as plan_fiscal_period,
P.fiscal_year                  as plan_fiscal_year,
P.total_raw_materials          as Plan_Raw_Materials,
P.total_fg_wip                 as Plan_FG_WIP,
P.total_power                  as Plan_Power,
P.total_fuel                   as Plan_Fuel,
P.total_labour                 as Plan_Labour,
P.total_depreciation           as Plan_Depreciation,
P.total_other_income           as Plan_Other_Income,
P.total_variable_cost          as Plan_Variable_Cost,
P.total_contribution           as Plan_Contribution,
P.total_employees_r_b          as Plan_Employees_R_B,
P.total_r_m_machinery          as Plan_R_M_Machinery,
P.total_insurance              as Plan_Insurance,
P.total_trvelling_expenses     as Plan_Trvelling_Expenses,
P.total_miscellaneous_expe      as Plan_Miscellaneous_Exp,
P.total_director_rem           as Plan_Director_Rem,
P.total_auditors_rem           as Plan_Auditors_Rem,
P.total_finance_charges        as Plan_Finance_Charges,
P.total_frt_ed_paid            as Plan_Frt_ED_Paid,
P.total_trading_profit         as Plan_Trading_Profit,
P.total_fixed_cost             as Plan_Fixed_Cost,
P.ebitda                       as Plan_EBITDA,
P.contribution_margin_percent  as Plan_Contribution_Percent,
P.ebitda_margin_percent        as Plan_EBITDA_Margin_Percent,
P.total_cost_of_production     as Plan_Cost_of_Production,
P.net_profit                   as Plan_Net_Profit,
P.total_cost_profit             as Plan_Cost_Profit,
P.total_p_b_t                  as Plan_P_B_T,
P.createdby                    as Plan_CreatedBy,
P.createdat                    as Plan_CreatedAt,
P.lastchangedby                as Plan_LastChangedBy,
P.lastchangedate               as Plan_LastChangedDate
}
