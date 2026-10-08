@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plan Final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_PLAN_FINAL
  as select from ZAPP02_PLAN
{
  key suid,
  key company_code,

  fiscal_year,
  fiscal_period,
  product,

  production_qty,
  sales_qty,

  revenue, 
  other_income,
  TotalVariableCost,
  fixed_cost,
  finance_charges,
  depreciation,

  transaction_currency,
  NR_SaleValue_Per_Quantity,
  MTN_SaleValue_Per_Quantity,
  ECU_SaleValue_Per_Quantity,
  createdby,
  createdon, 

  /* Contribution */
  
  revenue - TotalVariableCost as contribution,

  /* Contribution Margin % */
  
  case
    when revenue <> 0
      then ( ( revenue - TotalVariableCost ) * 100 ) / revenue
    else 0
  end as contribution_margin_pct,

  /* EBITDA */
  
  ( revenue - TotalVariableCost )
    + other_income
    - fixed_cost as ebitda_value,

  /* EBITDA % */
  
  case
    when revenue <> 0
      then (
        (
          ( revenue - TotalVariableCost )
          + other_income
          - fixed_cost
        ) * 100
      ) / revenue
    else 0
  end as ebitda_pct,

  /* PBT */
  
  (
    ( revenue - TotalVariableCost )
    + other_income
    - fixed_cost
    - finance_charges
    - depreciation
  ) as pbt

}
