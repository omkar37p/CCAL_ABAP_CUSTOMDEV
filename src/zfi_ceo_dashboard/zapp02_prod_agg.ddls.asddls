@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production AGG'''
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_Prod_AGG
    as select from I_GoodsMovementCube as B

    left outer join I_ProductUnitsOfMeasure as U
        on U.Product = B.Material
        and U.BaseUnit = B.MaterialBaseUnit

{
    key B.CompanyCode,

        B.PostingDate,
       
        substring(
            B.PostingDate,
            5,
            2
        ) as Fiscal_Period,

        substring(
            B.PostingDate,
            1,
            4
        ) as Fiscal_Year,

        B.Material,
        B.CompanyCodeCurrency,
        @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
        B.GoodsReceiptAmountInCoCodeCrcy,
        
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        B.GoodsReceiptQtyInBaseUnit,
        B.GoodsMovementType,
        B.MaterialBaseUnit,
        
        U.QuantityNumerator,
        U.QuantityDenominator,
        U.BaseUnit,
        B.ManufacturingOrder,
        
     case


            when B.CompanyCode = '1000'
                 and (
                      B.Material = '000000000030000000'
                   or B.Material = '000000000020000000'
                   or B.Material = '000000000030000001'
                 )
                 then cast( B.GoodsReceiptQtyInBaseUnit as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as ECU,
//                then 'ECU'
     
          case
            when B.CompanyCode = '2000'
                 and (                  
                        B.Material = '000000000015000001'
                     or B.Material = '000000000015000000'
                     or B.Material = '000000000015000002'
                     or B.Material = '000000000015000003'
                 
                 
//                      B.Material = '000000000030000010'
//                   or B.Material = '000000000030000691'
//                   or B.Material = '000000000030000692'
//                   or B.Material = '000000000030000690'
//                   or B.Material = '000000000030000700'
//                   or B.Material = '000000000030000707'
//                   or B.Material = '000000000030000694'
                 )
                  then cast( B.GoodsReceiptQtyInBaseUnit as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as MTN,
                 
//                then 'MTN'

           case
            when B.CompanyCode = '3000'
                 and (
                      B.Material = '000000000030000022'
                   or B.Material = '000000000030000027'
                   or B.Material = '000000000030000041'
                   or B.Material = '000000000030000043'
                   or B.Material = '000000000030000045'
                   or B.Material = '000000000030000016'
                   or B.Material = '000000000030000024'
                   or B.Material = '000000000030000033'
                   or B.Material = '000000000030000029'
                   or B.Material = '000000000030000014'
                   or B.Material = '000000000030000036'
                   or B.Material = '000000000030000034'
                   or B.Material = '000000000030000031'
                   or B.Material = '000000000030000015'
                   or B.Material = '000000000030000017'
                   or B.Material = '000000000030000023'
                   or B.Material = '000000000030000035'
                   or B.Material = '000000000030000039'
                   or B.Material = '000000000030000038'
                 )
                   then cast( B.GoodsReceiptQtyInBaseUnit as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as NR,
         
         
                 case


            when B.CompanyCode = '1000'
                 and (
                      B.Material = '000000000030000000'
                   or B.Material = '000000000020000000'
                   or B.Material = '000000000030000001'
                 )
                 then cast( B.GoodsReceiptAmountInCoCodeCrcy as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as ECU_AMOUNT,
//                then 'ECU'
     
          case
            when B.CompanyCode = '2000'
                 and (
                 
                        B.Material = '000000000015000001'
                     or B.Material = '000000000015000000'
                     or B.Material = '000000000015000002'
                     or B.Material = '000000000015000003'
                 
//                      B.Material = '000000000030000010'
//                   or B.Material = '000000000030000691'
//                   or B.Material = '000000000030000692'
//                   or B.Material = '000000000030000690'
//                   or B.Material = '000000000030000700'
//                   or B.Material = '000000000030000707'
//                   or B.Material = '000000000030000694'
                 )
                  then cast( B.GoodsReceiptAmountInCoCodeCrcy as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as MTN_AMOUNT,
                 
//                then 'MTN'

           case
            when B.CompanyCode = '3000'
                 and (
                      B.Material = '000000000030000022'
                   or B.Material = '000000000030000027'
                   or B.Material = '000000000030000041'
                   or B.Material = '000000000030000043'
                   or B.Material = '000000000030000045'
                   or B.Material = '000000000030000016'
                   or B.Material = '000000000030000024'
                   or B.Material = '000000000030000033'
                   or B.Material = '000000000030000029'
                   or B.Material = '000000000030000014'
                   or B.Material = '000000000030000036'
                   or B.Material = '000000000030000034'
                   or B.Material = '000000000030000031'
                   or B.Material = '000000000030000015'
                   or B.Material = '000000000030000017'
                   or B.Material = '000000000030000023'
                   or B.Material = '000000000030000035'
                   or B.Material = '000000000030000039'
                   or B.Material = '000000000030000038'
                 )
         then cast( B.GoodsReceiptAmountInCoCodeCrcy as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as NR_AMOUNT  

}

where
      ( B.GoodsMovementType = '101'
        or B.GoodsMovementType = '102' )
  and B.ManufacturingOrder is not initial

//where 
//B.GoodsMovementType = '101'
//or B.GoodsMovementType = '102'
//and  B.ManufacturingOrder <> ''

