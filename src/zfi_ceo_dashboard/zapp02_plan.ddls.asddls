@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant Address Root View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_PLAN  as select from zapp02_plan_data
{

  key suid,

  key company_code,
   fiscal_period,
   fiscal_year,
  product,
 
  production_qty,
  sales_qty, 

  revenue,
  other_income,
  totalvariablecost,
  fixed_cost,
  finance_charges,
  depreciation,

  transaction_currency,
  nr_salevalue_per_quantity,
  mtn_salevalue_per_quantity,
  ecu_salevalue_per_quantity,

  createdby,
  createdon
}
