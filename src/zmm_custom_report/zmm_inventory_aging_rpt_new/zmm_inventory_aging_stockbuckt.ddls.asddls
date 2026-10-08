@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Agg - Prod/Plant/Sloc/Bucket'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_INVENTORY_AGING_STOCKBUCKT 
as select from I_MaterialStock_2 as MS 
left outer join ZMM_INVENTORY_AGING_RV as SS on    SS.Product = MS.Material
                                                   and SS.Plant = MS.Plant
                                                   and SS.StorageLocation = MS.StorageLocation
                                                   and SS.InventorySpecialStockType = MS.InventorySpecialStockType
                                                                           
                                                                             
left outer join I_Plant                 as plnt       on plnt.Plant = MS.Plant
left outer join I_CompanyCode           as ccode      on ccode.CompanyCode = MS.CompanyCode
left outer join I_ProductDescription_2  as matdesc    on  matdesc.Product  = MS.Material
                                                      and matdesc.Language = $session.system_language
left outer join I_StorageLocation       as sloc       on sloc.Plant = MS.Plant
                                                      and sloc.StorageLocation = MS.StorageLocation
left outer join I_InventorySpecialStockTypeT as spclstock   on spclstock.InventorySpecialStockType = MS.InventorySpecialStockType
                                                           and spclstock.Language = $session.system_language                                                 
left outer join ZMM_INVENTORY_AGING_OVERDUE as overdue on overdue.Product = MS.Material
                                    and overdue.Plant = MS.Plant
                                    and overdue.StorageLocation = MS.StorageLocation
                                    and overdue.InventorySpecialStockType = MS.InventorySpecialStockType 
 //left outer join I_MaterialDocumentItem_2 as mdi on mdi.Material = MS.Material 
                                            //  and mdi.Supplier = MS.Supplier                                
{
  key SS. Product,
    key SS.Plant,
    key SS.StorageLocation,
    key SS.InventorySpecialStockType,
    key SS.InventoryStockType,   
    key SS.SDDocument,
    plnt.PlantName as PlantName,
    ccode.CompanyCode as CompanyCode,
    matdesc.ProductDescription as ProductDescription,
    sloc.StorageLocationName as StorageLocationName,
    spclstock.InventorySpecialStockTypeName as InventorySpecialStockTypeName,
    SS.MaterialBaseUnit,
    SS.ProductGroup as ProductGroupDescn,
   // SS.SDDocumentItem,
   SS.Supplier,
  //  MS.Customer,
 // mdi.Supplier,
    SS.SDDocument as Salesorder,
    SS.SDDocumentItem as Salesorderitem,
    SS.Quantity,
    SS.ProductType,
    SS.NSDM_Display_Currency,
    SS.StockValueInDisplayCurrency,
   max( MS.MatlDocLatestPostgDate ) as MatlDocLatestPostgDate,
   
//   coalesce( overdue.Overdue_Days, 0 ) as Overdue_Days,
      overdue.Overdue_Days,
//    cast( coalesce(overdue.Overdue_Days,0) as abap.int4 ) as Overdue_Days,
               
case
    when overdue.Overdue_Days between 0 and 30
    then SS.Quantity
    else null
end as Quantity_30,

case
    when overdue.Overdue_Days between 0 and 30
    then SS.StockValueInDisplayCurrency
    else null
end as Value_30,

case
    when overdue.Overdue_Days between 31 and 60
    then SS.Quantity
    else null
end as Quantity_60,

case
    when overdue.Overdue_Days between 31 and 60
    then SS.StockValueInDisplayCurrency
    else null
end as Value_60,

case
    when overdue.Overdue_Days between 61 and 90
    then SS.Quantity
    else null
end as Quantity_90,

case
    when overdue.Overdue_Days between 61 and 90
    then SS.StockValueInDisplayCurrency
    else null
end as Value_90,

case
    when overdue.Overdue_Days between 91 and 120
    then SS.Quantity
    else null
end as Quantity_120,

case
    when overdue.Overdue_Days between 91 and 120
    then SS.StockValueInDisplayCurrency
    else null
end as Value_120,

case
    when overdue.Overdue_Days between 121 and 150
    then SS.Quantity
    else null
end as Quantity_150,

case
    when overdue.Overdue_Days between 121 and 150
    then SS.StockValueInDisplayCurrency
    else null
end as Value_150,

case
    when overdue.Overdue_Days between 151 and 180
    then SS.Quantity
    else null
end as Quantity_180,

case
    when overdue.Overdue_Days between 151 and 180
    then SS.StockValueInDisplayCurrency
    else null
end as Value_180,

case
    when overdue.Overdue_Days between 181 and 365
    then SS.Quantity
    else null
end as Quantity_365,

case
    when overdue.Overdue_Days between 181 and 365
    then SS.StockValueInDisplayCurrency
    else null
end as Value_365,

case
    when overdue.Overdue_Days > 365
    then SS.Quantity
    else null
end as Quantity_bucket,

case
    when overdue.Overdue_Days > 365
    then SS.StockValueInDisplayCurrency
    else null
end as Value_bucket   
   
}
where
   ( SS.Quantity <> 0 or SS.StockValueInDisplayCurrency <> 0 )

group by
    SS. Product,
    SS.Plant,
    SS.StorageLocation,
    SS.InventorySpecialStockType,
    SS.InventoryStockType,
    SS.MaterialBaseUnit,
    SS.SDDocument,
    plnt.PlantName,
    ccode.CompanyCode,
    matdesc.ProductDescription,
    SS.ProductGroup,
    sloc.StorageLocationName,
    spclstock.InventorySpecialStockTypeName,
   SS.Supplier,
   // MS.Customer,
  // mdi.Supplier,
   SS.SDDocument,
    SS.SDDocumentItem,
    SS.Quantity,
    SS.ProductType,
    SS.NSDM_Display_Currency,
    SS.StockValueInDisplayCurrency,
    overdue.Overdue_Days,
    overdue.MatlDocLatestPostgDate 
