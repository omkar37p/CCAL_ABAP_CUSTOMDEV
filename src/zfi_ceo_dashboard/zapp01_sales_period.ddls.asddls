   @AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Period'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZAPP01_SALES_PERIOD
  as select from I_BillingDocumentItem as B

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

        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
        case

            when B.BillingQuantityUnit = 'M'
                then B.BillingQuantity

            when B.BillingQuantityUnit = 'KG'
                then
                    B.BillingQuantity
                    *
                    division(
                        cast( U.QuantityNumerator as abap.dec(15,5) ),
                        cast( U.QuantityDenominator as abap.dec(15,5) ),
                        5
                    )

            else
                B.BillingQuantity

        end as ConversionQuantity,

        case


            when B.CompanyCode = '1000'
                 and (
                      B.Product = '30000000'
                   or B.Product = '20000000'
                   or B.Product = '30000001'
                 )
                then 'ECU'


            when B.CompanyCode = '2000'
                 and (
                      B.Product = '30000010'
                   or B.Product = '30000691'
                   or B.Product = '30000692'
                   or B.Product = '30000690'
                   or B.Product = '30000700'
                   or B.Product = '30000707'
                   or B.Product = '30000694'
                 )
                then 'MTN'


            when B.CompanyCode = '3000'
                 and (
                      B.Product = '30000022'
                   or B.Product = '30000027'
                   or B.Product = '30000041'
                   or B.Product = '30000043'
                   or B.Product = '30000045'
                   or B.Product = '30000016'
                   or B.Product = '30000024'
                   or B.Product = '30000033'
                   or B.Product = '30000029'
                   or B.Product = '30000014'
                   or B.Product = '30000036'
                   or B.Product = '30000034'
                   or B.Product = '30000031'
                   or B.Product = '30000015'
                   or B.Product = '30000017'
                   or B.Product = '30000023'
                   or B.Product = '30000035'
                   or B.Product = '30000039'
                   or B.Product = '30000038'
                 )
                then 'NR'

            else 'OTHER'

        end as SalesCategory,

        @Semantics.amount.currencyCode: 'TransactionCurrency'
        B.NetAmount,

        B.TransactionCurrency

}







//define view entity ZAPP01_SALES_period
//  as select from I_BillingDocumentItem as B
//
//    left outer join I_ProductUnitsOfMeasure as U
//      on  B.Product = U.Product
//      and U.BaseUnit = B.BaseUnit
//      and U.AlternativeUnit = B.BillingQuantityUnit
//
//{
//    key B.BillingDocument,
//    key B.BillingDocumentItem,
//        B.CompanyCode,
//        B.BillingDocumentDate as BillingDate,
//        
//        substring(B.BillingDocumentDate,5,2) as Fiscal_Period,
//        substring(B.BillingDocumentDate,1,4) as Fiscal_Year,
//
//        B.BillingDocumentType,
//        B.Product,
//        B.BillingDocumentItemText as ProductDescription,
//        
//        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
//        B.BillingQuantity,
//        B.BillingQuantityUnit,
//        B.BaseUnit,
//
//        U.QuantityNumerator,
//        U.QuantityDenominator,
//        U.AlternativeUnit,
//
//        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
//        case
//
//            // Already in base unit M
//            when B.BillingQuantityUnit = 'm'
//                then B.BillingQuantity
//
//            // KG -> M
//            when B.BillingQuantityUnit = 'kg'
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
//
//        @Semantics.amount.currencyCode: 'TransactionCurrency'
//        B.NetAmount,
//
//        B.TransactionCurrency
//
//}
//where
//       B.Product = '000000000030000000'
//    or B.Product = '000000000020000000'
//    or B.Product = '000000000030000001';











//define view entity ZAPP01_SALES_period
//  as select from I_BillingDocumentItem
//{
//    key BillingDocument,
//
//    CompanyCode,
//
//    BillingDocumentDate as BillingDate,
//
//    substring( BillingDocumentDate, 5, 2 ) as Fiscal_Period,
//
//    substring( BillingDocumentDate, 1, 4 ) as Fiscal_Year,
//
//    BillingDocumentType,
//
//    Product,
//
//    BillingDocumentItemText as ProductDescription,
//
//    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
//    BillingQuantity,
//
//    BillingQuantityUnit,
//    BaseUnit,
//
//    @Semantics.amount.currencyCode: 'TransactionCurrency'
//    NetAmount,
//
//    TransactionCurrency
//}
//where
//       Product = '000000000030000000'
//    or Product = '000000000020000000'
//    or Product = '000000000030000001';
    
    
    
    
