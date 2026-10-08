@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Periods'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP01_PROD_PERIOD
as select from I_GoodsMovementCube as B

left outer join I_ProductUnitsOfMeasure as U
      on  U.Product = B.Material

      and U.AlternativeUnit  = B.MaterialBaseUnit
{
    key B.CompanyCode,
  
        B.PostingDate ,
        substring(B.PostingDate, 5, 2) as Fiscal_Period,
        substring(B.PostingDate, 1, 4) as Fiscal_Year,
        B.Material,
        
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        B.GoodsIssueQtyInBaseUnit,

        B.MaterialBaseUnit,
        U.QuantityNumerator,
        U.QuantityDenominator,
        U.AlternativeUnit,

       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'

case

    when B.MaterialBaseUnit = 'M'
        then
            cast(
                B.GoodsIssueQtyInBaseUnit as abap.dec(15,5)
            )

    when B.MaterialBaseUnit = 'KG'
        then
            cast(
                B.GoodsIssueQtyInBaseUnit as abap.dec(15,5)
            )
            *
            division(
                cast(
                    U.QuantityNumerator as abap.dec(15,5)
                ),
                cast(
                    U.QuantityDenominator as abap.dec(15,5)
                ),
                5
            )

    else
        cast(
            B.GoodsIssueQtyInBaseUnit as abap.dec(15,5)
        )

end as ConversionQuantity,

        case


            when B.CompanyCode = '1000'
                 and (
                      B.Material = '30000000'
                   or B.Material = '20000000'
                   or B.Material = '30000001'
                 )
                then 'ECU'


            when B.CompanyCode = '2000'
                 and (
                      B.Material = '30000010'
                   or B.Material = '30000691'
                   or B.Material = '30000692'
                   or B.Material = '30000690'
                   or B.Material = '30000700'
                   or B.Material = '30000707'
                   or B.Material = '30000694'
                 )
                then 'MTN'


            when B.CompanyCode = '3000'
                 and (
                      B.Material = '30000022'
                   or B.Material = '30000027'
                   or B.Material = '30000041'
                   or B.Material = '30000043'
                   or B.Material = '30000045'
                   or B.Material = '30000016'
                   or B.Material = '30000024'
                   or B.Material = '30000033'
                   or B.Material = '30000029'
                   or B.Material = '30000014'
                   or B.Material = '30000036'
                   or B.Material = '30000034'
                   or B.Material = '30000031'
                   or B.Material = '30000015'
                   or B.Material = '30000017'
                   or B.Material = '30000023'
                   or B.Material = '30000035'
                   or B.Material = '30000039'
                   or B.Material = '30000038'
                 )
                then 'NR'

            else 'OTHER'

        end as SalesCategory

}









//{
//key CompanyCode,
//PostingDate,
//        substring( PostingDate, 5, 2 ) as Fiscal_Period,
//        substring( PostingDate, 1, 4 ) as Fiscal_Year,
//        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//        GoodsIssueQtyInBaseUnit,
//        MaterialBaseUnit,
//        Material
//        }
//        where
//       Material = '000000000030000000'
//    or Material = '000000000020000000'
//    or Material = '000000000030000001'


