@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Plan Projection View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZAPP02_SALES_PLAN_PV
 provider contract transactional_query 
 as projection on ZAPP02_SALES_PLAN
{
    key companycode,
    key fiscalyear,
    key fiscalperiod,
    key product,
    planquantity,
    planamount,
    conversionquantity,
    transactioncurrency,
    SalesCategory
//    createdby,
//    createdon
}
