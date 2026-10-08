@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI PLAN PV Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define root view entity ZAPP03_FI_PLAN_PV provider contract transactional_query
  as projection on ZAPP03_FI_PLAN
{
    key fiscal_year, 
    key fiscal_period ,
    total_raw_materials ,
    total_fg_wip ,
    total_power ,
    total_fuel,
    total_labour ,
    total_depreciation ,
    total_other_income ,
    total_variable_cost ,
    total_contribution ,
    total_employees_r_b ,
    total_r_m_machinery ,
    total_insurance ,
    total_trvelling_expenses ,
    total_miscellaneous_expe ,
    total_director_rem ,
    total_auditors_rem ,
    total_finance_charges ,
    total_frt_ed_paid ,
    total_trading_profit ,
    total_fixed_cost ,
    ebitda ,
    contribution_margin_percent ,
    ebitda_margin_percent ,
    total_cost_of_production ,
    net_profit ,
    total_cost_profit ,
    total_p_b_t ,
    createdat,
    createdby,
    lastchangedate,
    lastchangedby
    
    
}
