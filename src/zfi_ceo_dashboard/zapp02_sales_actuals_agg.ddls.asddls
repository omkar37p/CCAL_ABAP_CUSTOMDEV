@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Actualls AGG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_SALES_Actuals_AGG as select from I_BillingDocumentItem as B

    left outer join I_ProductUnitsOfMeasure as U
      on  U.Product = B.Product
      and U.BaseUnit = B.BaseUnit
      and U.AlternativeUnit = B.BillingQuantityUnit
         

{
    key B.BillingDocument,
    key B.BillingDocumentItem,
        B.CompanyCode, 
        B.BillingDocumentDate as BillingDate,
        substring(B.BillingDocumentDate, 5, 2) as Fiscal_Period,
        substring(B.BillingDocumentDate, 1, 4) as Fiscal_Year,
        B.BillingDocumentType,
        B.Product,
        B.BillingDocumentItemText as ProductDescription,
        
        @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
        B.BillingQuantity,

        B.BillingQuantityUnit,
        B.BaseUnit,
        U.QuantityNumerator,
        U.QuantityDenominator,
        U.AlternativeUnit,


//        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
//        case
//
//            when B.BillingQuantityUnit = 'M'
//                then B.BillingQuantity
//
//            when B.BillingQuantityUnit = 'KG'
//                then
//                    B.BillingQuantity
//                    *
//                    division(
//                        cast( U.QuantityNumerator as abap.dec(15,5) ),
//                        cast( U.QuantityDenominator as abap.dec(15,5) ),
//                        5
//                    )
//
//            else
//                B.BillingQuantity
//
//        end as ConversionQuantity,

        case


            when B.CompanyCode = '1000'
                 and (
                      B.Product = '000000000030000000'
                   or B.Product = '000000000020000000'
                   or B.Product = '000000000030000001'
                 )
                 then cast( B.BillingQuantity as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as ECU,
//                then 'ECU'
     
          case
            when B.CompanyCode = '2000'
                 and (
                      B.Product = '000000000015000000'
                   or B.Product = '000000000015000001'
                   or B.Product = '000000000015000002'
                   or B.Product = '000000000015000003'
//                   or B.Product = '000000000030000700'
//                   or B.Product = '000000000030000707'
//                   or B.Product = '000000000030000694'
                 )
                  then cast( B.BillingQuantity as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as MTN,
                 
//                then 'MTN'

           case
            when B.CompanyCode = '3000'
                 and (
                      B.Product = '000000000030000022'
                   or B.Product = '000000000030000027'
                   or B.Product = '000000000030000041'
                   or B.Product = '000000000030000043'
                   or B.Product = '000000000030000045'
                   or B.Product = '000000000030000016'
                   or B.Product = '000000000030000024'
                   or B.Product = '000000000030000033'
                   or B.Product = '000000000030000029'
                   or B.Product = '000000000030000014'
                   or B.Product = '000000000030000036'
                   or B.Product = '000000000030000034'
                   or B.Product = '000000000030000031'
                   or B.Product = '000000000030000015'
                   or B.Product = '000000000030000017'
                   or B.Product = '000000000030000023'
                   or B.Product = '000000000030000035'
                   or B.Product = '000000000030000039'
                   or B.Product = '000000000030000038'
                 )
                                                 then cast( B.BillingQuantity as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as NR,
         
         
                 case


            when B.CompanyCode = '1000'
                 and (
                      B.Product = '000000000030000000'
                   or B.Product = '000000000020000000'
                   or B.Product = '000000000030000001'
                 )
                 then cast( B.NetAmount as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as ECU_AMOUNT,
//                then 'ECU'
     
          case
            when B.CompanyCode = '2000'
                 and (
                      B.Product = '000000000030000010'
                   or B.Product = '000000000030000691'
                   or B.Product = '000000000030000692'
                   or B.Product = '000000000030000690'
                   or B.Product = '000000000030000700'
                   or B.Product = '000000000030000707'
                   or B.Product = '000000000030000694'
                 )
                  then cast( B.NetAmount as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as MTN_Amount,
                 
//                then 'MTN'

           case
            when B.CompanyCode = '3000'
                 and (
                      B.Product = '000000000030000022'
                   or B.Product = '000000000030000027'
                   or B.Product = '000000000030000041'
                   or B.Product = '000000000030000043'
                   or B.Product = '000000000030000045'
                   or B.Product = '000000000030000016'
                   or B.Product = '000000000030000024'
                   or B.Product = '000000000030000033'
                   or B.Product = '000000000030000029'
                   or B.Product = '000000000030000014'
                   or B.Product = '000000000030000036'
                   or B.Product = '000000000030000034'
                   or B.Product = '000000000030000031'
                   or B.Product = '000000000030000015'
                   or B.Product = '000000000030000017'
                   or B.Product = '000000000030000023'
                   or B.Product = '000000000030000035'
                   or B.Product = '000000000030000039'
                   or B.Product = '000000000030000038'
                 )
                                                 then cast( B.NetAmount as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as NR_Amount,
//                then 'NR'
//
//            else 'OTHER'
//
//        end as SalesCategory,

        @Semantics.amount.currencyCode: 'TransactionCurrency'
        B.NetAmount,

        B.TransactionCurrency

}




