@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Plan'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZAPP02_SALES_PLAN
  as select from zapp02_sales_p
{
    key companycode,
    key fiscalyear,
    key fiscalperiod,
    key product,

    planquantity,
    planamount,
    conversionquantity,
    transactioncurrency,

    case

        when companycode = '1000'
             and (
                    product = '30000000'
                 or product = '20000000'
                 or product = '30000001'
                )
            then 'ECU'

        when companycode = '2000'
             and (
                    product = '30000010'
                 or product = '30000691'
                 or product = '30000692'
                 or product = '30000690'
                 or product = '30000700'
                 or product = '30000707'
                 or product = '30000694'
                )
            then 'MTN'

        when companycode = '3000'
             and (
                    product = '30000022'
                 or product = '30000027'
                 or product = '30000041'
                 or product = '30000043'
                 or product = '30000045'
                 or product = '30000016'
                 or product = '30000024'
                 or product = '30000033'
                 or product = '30000029'
                 or product = '30000014'
                 or product = '30000036'
                 or product = '30000034'
                 or product = '30000031'
                 or product = '30000015'
                 or product = '30000017'
                 or product = '30000023'
                 or product = '30000035'
                 or product = '30000039'
                 or product = '30000038'
                )
            then 'NR'

        else 'OTHER'

    end as SalesCategory,
    createdby,
    createdon
    
}
