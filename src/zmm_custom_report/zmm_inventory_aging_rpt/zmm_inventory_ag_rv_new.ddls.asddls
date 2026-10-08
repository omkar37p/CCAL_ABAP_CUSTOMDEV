@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROOTENTITY'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_INVENTORY_AG_RV_NEW 
as select from I_StockQuantityCurrentValue_2 ( P_DisplayCurrency: 'INR' ) as stc
 left outer join I_Batch                                                    as bc    on  bc.Plant              =  stc.Plant
                                                                                        and bc.Material           =  stc.Product
                                                                                        and bc.Batch              =  stc.Batch

                                                                                        and bc.IsSubordinateBatch <> ' '
    left outer join I_StorageLocation                                          as st    on  st.Plant           = stc.Plant
                                                                                        and st.StorageLocation = stc.StorageLocation
    left outer join I_Product                                                  as pd    on  pd.Product     = stc.Product
                                                                                        and pd.ProductType = stc.ProductType

    left outer join I_ProductText                                              as pt    on  pt.Product  = stc.Product
                                                                                        and pt.Language = 'E'
    left outer join I_ProductGroupText_2                                       as Pdesc on  Pdesc.ProductGroup = pd.ProductGroup
                                                                                        and Pdesc.Language     = 'E'

  left outer join ZMM_INVENTORY_AG_VIEW                                               as ms    on  ms.Material            = stc.Product

                                                                                        and ms.Plant               = stc.Plant
                                                                                        and ms.Batch               = stc.Batch
//                                                                                         and ms.InventoryStockType = stc.InventoryStockType
                                                                                        and ms.StorageLocation     = st.StorageLocation
//                                                                                        and ms.CompanyCode = ms.CompanyCode


{
  key        stc.Product                                                            as mat,
  key        stc.Batch                                                              as Batch,
  key        stc.Plant                                                              as Plant,
  key        stc.StorageLocation                                                    as StorageL,
             //                     ms.GoodsMovementType                                                                     as Mty,
  key        ms.CompanyCode                                                         as Companycode,
  
//  key        stc.Supplier,
//NEW ADD HIMANSU
 key ms.Supplier                                                                     as Supplier,
 //NEW ADD HIMANSU
  @Semantics.quantity.unitOfMeasure: 'uom'
  key        stc.MatlWrhsStkQtyInMatlBaseUnit                                       as currentstockqty,
//  key        ms.MaterialDocument                                                     as Materialdoc,
  //                     ms.DocumentDate                                                                 as Materialdate,
             
             stc.MaterialBaseUnit                                                   as uom,
//           @Semantics.quantity.unitOfMeasure: 'uom'
//           stc.MatlWrhsStkQtyInMatlBaseUnit                                       as currentstockqty,
             pd.ProductType                                                         as materialtype,
             st.StorageLocationName                                                 as stroagelocationname,
             bc.ManufactureDate                                                     as Batchmafdate,
             bc.ManufactureDate                                                     as Batchmafdate1,
             bc.ShelfLifeExpirationDate                                             as BatchExpDate,
             pt.ProductName                                                         as materialdesc,
             cast( dats_days_between(ms.Pos ,  $session.system_date )as abap.int8 ) as Nonmovingdays,
             //             max(ms.Pos) as Postingday,
             stc.DisplayCurrency                                                    as cucy,
             @Semantics.amount.currencyCode: 'cucy'
             stc.StockValueInCCCrcy                                                 as Currentstocka,
             $session.system_date                                                   as Postingd,
             ms.Pos,
             ms.sales,
             ms.Sitem,
             ms.Customer,
        
             Pdesc.ProductGroupName                                                 as Productgroupname,
             //             matd.PostingDate as lastconsumptiond,

             @Semantics.amount.currencyCode: 'Cucy'
             case
             when  cast( dats_days_between(  ms.Pos,  $session.system_date )as abap.int8 ) <= 30 and stc.DisplayCurrency  = 'INR'
             then stc.StockValueInCCCrcy
             else null end                                                          as Amt30,

             @Semantics.quantity.unitOfMeasure: 'uom'
             case
             when  cast( dats_days_between(  ms.Pos,  $session.system_date )as abap.int8 )  <= 30
             then  stc.MatlWrhsStkQtyInMatlBaseUnit
             else null end                                                          as Qty30,

             @Semantics.amount.currencyCode: 'Cucy'
             case
             when   cast( dats_days_between(  ms.Pos,  $session.system_date )as abap.int8 )  >= 31
                 and cast( dats_days_between(  ms.Pos,  $session.system_date )as abap.int8 )  <= 60 and stc.DisplayCurrency  = 'INR'
             then stc.StockValueInCCCrcy
             else null end                                                          as Amt60,

             @Semantics.quantity.unitOfMeasure: 'uom'
             case
             when    cast( dats_days_between(  ms.Pos,  $session.system_date )as abap.int8 )  >= 31
                 and  cast( dats_days_between(  ms.Pos,  $session.system_date )as abap.int8 )  <= 60
             then  stc.MatlWrhsStkQtyInMatlBaseUnit
             else null end                                                          as Qty60,

             @Semantics.amount.currencyCode: 'Cucy'
             case
             when  cast( dats_days_between(  ms.Pos,  $session.system_date )as abap.int8 )  >= 61
                 and cast( dats_days_between(  ms.Pos,  $session.system_date )as abap.int8 ) <= 90 and stc.DisplayCurrency  = 'INR'
             then stc.StockValueInCCCrcy
             else null end                                                          as Amt90,

             @Semantics.quantity.unitOfMeasure: 'uom'
             case
             when    cast( dats_days_between(  ms.Pos,  $session.system_date )as abap.int8 )  >= 61
                 and cast( dats_days_between(  ms.Pos,  $session.system_date )as abap.int8 )  <= 90
             then stc.MatlWrhsStkQtyInMatlBaseUnit
             else null end                                                          as Qty90,

             @Semantics.amount.currencyCode: 'Cucy'
             case
             when    cast( dats_days_between( ms.Pos,  $session.system_date) as abap.int8 )  >= 91
                 and cast( dats_days_between( ms.Pos,  $session.system_date ) as abap.int8 )  <= 180 and stc.DisplayCurrency  = 'INR'
             then stc.StockValueInCCCrcy
             else null end                                                          as Amt180,

             @Semantics.quantity.unitOfMeasure: 'uom'
             case
             when    cast( dats_days_between( ms.Pos,  $session.system_date ) as abap.int8 )  >= 91
                 and cast( dats_days_between( ms.Pos,  $session.system_date ) as abap.int8 )  <= 180  //and ms.DisplayCurrency  = 'INR'
             then stc.MatlWrhsStkQtyInMatlBaseUnit
             else null end                                                          as Qty180,

             @Semantics.amount.currencyCode: 'Cucy'
             case
             when    cast( dats_days_between( ms.Pos,  $session.system_date ) as abap.int8 )  >= 181
                 and cast( dats_days_between( ms.Pos,  $session.system_date ) as abap.int8 )  <= 365 and stc.DisplayCurrency  = 'INR'
             then stc.StockValueInCCCrcy
             else null end                                                          as Amt365,


             @Semantics.quantity.unitOfMeasure: 'uom'
             case
             when    cast( dats_days_between( ms.Pos,  $session.system_date ) as abap.int8 )  >= 181
                 and cast( dats_days_between( ms.Pos,  $session.system_date ) as abap.int8 )  <= 365  //and ms.DisplayCurrency  = 'INR'
             then stc.MatlWrhsStkQtyInMatlBaseUnit
             else null end                                                          as Qty365,

             @Semantics.amount.currencyCode: 'Cucy'
             case
             when    cast( dats_days_between( ms.Pos,  $session.system_date ) as abap.int8 )  >= 366
                  and stc.DisplayCurrency  = 'INR'
             then stc.StockValueInCCCrcy
             else null end                                                          as Amt1year,


             @Semantics.quantity.unitOfMeasure: 'uom'
             case
             when    cast( dats_days_between( ms.Pos,  $session.system_date ) as abap.int8 )  >= 366 //  and ms.DisplayCurrency  = 'INR'
             then stc.MatlWrhsStkQtyInMatlBaseUnit
             else null end                                                          as Qty1year



}

where
      stc.ValuationAreaType  =  '1'
  and stc.StockValueInCCCrcy <> abap.curr'0.00'

