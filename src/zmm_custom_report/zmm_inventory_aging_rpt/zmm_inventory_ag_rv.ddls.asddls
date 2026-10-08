@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'INVENTORY AGING REPORT ROOT VIEW'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZMM_INVENTORY_AG_RV
 

  as select from    I_StockQuantityCurrentValue_2 ( P_DisplayCurrency: 'INR' ) as stc

  left outer join I_Batch as bc on bc.Plant = stc.Plant
                                  and bc.Material = stc.Product
                                  and bc.Batch = stc.Batch
                                  and bc.IsSubordinateBatch <> ' '

  left outer join I_StorageLocation as st on st.Plant = stc.Plant
                                           and st.StorageLocation = stc.StorageLocation

  left outer join I_Product as pd on pd.Product = stc.Product
                                  and pd.ProductType = stc.ProductType

  left outer join I_ProductText as pt on pt.Product = stc.Product
                                      and pt.Language = 'E'

  left outer join I_ProductGroupText_2 as Pdesc on Pdesc.ProductGroup = pd.ProductGroup
                                                and Pdesc.Language = 'E'

  left outer join ZINC_DATE_V as ms on ms.Material = stc.Product
                                    and ms.Plant = stc.Plant
                                    and ms.Batch = stc.Batch
                                    and ms.StorageLocation = st.StorageLocation



    left outer join ZMM_INVENTORY_NONMOVING_BASE    as nmb on nmb.Material      = ms.Material
                                                  and nmb.Plant         = ms.Plant
                                                  and nmb.Batch         = ms.Batch
                                                  and nmb.StorageLocation = ms.StorageLocation

    left outer join I_Supplier           as supplier on supplier.Supplier = ms.Supplier
    left outer join I_Customer           as customer on customer.Customer = ms.Customer

{
  

  key stc.Product              as mat,
  key stc.Plant                as Plant,
  key stc.StorageLocation      as StorageL,
  key stc.Batch                as Batch,
  key ms.Pos                   as PostingDate,

      ms.CompanyCode                   as Companycode,
     
  stc.MaterialBaseUnit         as uom,

  

  @Semantics.quantity.unitOfMeasure: 'uom'
      stc.MatlWrhsStkQtyInMatlBaseUnit as currentstockqty,

      pd.ProductType                   as materialtype,
      st.StorageLocationName           as stroagelocationname,
      ms.Pos1                          as Batchmafdate,
      bc.ShelfLifeExpirationDate       as BatchExpDate,
      pt.ProductName                   as materialdesc,

      nmb.NonMovingDays                as Nonmovingdayss,

      stc.DisplayCurrency              as cucy,

  @Semantics.amount.currencyCode: 'cucy'
      stc.StockValueInCCCrcy           as Currentstocka,

      ms.Pos                           as Pos1tingday,
      ms.sales,
      ms.Sitem,
      ms.Customer,
      ms.Supplier,
      customer.CustomerName            as CustomerName,
      supplier.SupplierName            as SupplierName,
      Pdesc.ProductGroupName           as Productgroup,

  // Inventory Ageing Buckets
  @Semantics.amount.currencyCode: 'cucy'
  case when nmb.NonMovingDays <= 30 then stc.StockValueInCCCrcy else null end as Amt30,

  @Semantics.quantity.unitOfMeasure: 'uom'
  case when nmb.NonMovingDays <= 30 then stc.MatlWrhsStkQtyInMatlBaseUnit else null end as Qty30,

  @Semantics.amount.currencyCode: 'cucy'
  case when nmb.NonMovingDays between 31 and 60 then stc.StockValueInCCCrcy else null end as Amt60,

  @Semantics.quantity.unitOfMeasure: 'uom'
  case when nmb.NonMovingDays between 31 and 60 then stc.MatlWrhsStkQtyInMatlBaseUnit else null end as Qty60,

  @Semantics.amount.currencyCode: 'cucy'
  case when nmb.NonMovingDays between 61 and 90 then stc.StockValueInCCCrcy else null end as Amt90,

  @Semantics.quantity.unitOfMeasure: 'uom'
  case when nmb.NonMovingDays between 61 and 90 then stc.MatlWrhsStkQtyInMatlBaseUnit else null end as Qty90,

  @Semantics.amount.currencyCode: 'cucy'
  case when nmb.NonMovingDays between 91 and 180 then stc.StockValueInCCCrcy else null end as Amt180,

  @Semantics.quantity.unitOfMeasure: 'uom'
  case when nmb.NonMovingDays between 91 and 180 then stc.MatlWrhsStkQtyInMatlBaseUnit else null end as Qty180,

  @Semantics.amount.currencyCode: 'cucy'
  case when nmb.NonMovingDays between 181 and 365 then stc.StockValueInCCCrcy else null end as Amt365,

  @Semantics.quantity.unitOfMeasure: 'uom'
  case when nmb.NonMovingDays between 181 and 365 then stc.MatlWrhsStkQtyInMatlBaseUnit else null end as Qty365,

  @Semantics.amount.currencyCode: 'cucy'
  case when nmb.NonMovingDays >= 366 then stc.StockValueInCCCrcy else null end as Amt1year,

  @Semantics.quantity.unitOfMeasure: 'uom'
  case when nmb.NonMovingDays >= 366 then stc.MatlWrhsStkQtyInMatlBaseUnit else null end as Qty1year

}
//where
   //   stc.ValuationAreaType = '1'
  //and stc.StockValueInCCCrcy <> abap.curr'0.00'
 // and stc.Product is not null
  //  and stc.Product <> ''

   
