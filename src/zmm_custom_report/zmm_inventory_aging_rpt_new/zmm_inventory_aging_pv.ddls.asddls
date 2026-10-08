@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZMM_INVENTORY_AGING_PV as select from ZMM_INVENTORY_AGING_STOCKBUCKT
{
  
  key Product,
  key Plant,
  key StorageLocation,
  key InventorySpecialStockType,
  key InventoryStockType,
  key SDDocument,
  PlantName,
  CompanyCode,
  ProductDescription,
  //ProductGroup,
  ProductGroupDescn,
  StorageLocationName,
  InventorySpecialStockTypeName,
  Supplier,
  MaterialBaseUnit,
 // Customer,
  ProductType as Materialtype,
//  SDDocumentItem,
Salesorderitem,
  Quantity,
  NSDM_Display_Currency,
  StockValueInDisplayCurrency,
  @EndUserText.label: 'Posting Date'
  MatlDocLatestPostgDate as Postingdate,
  Overdue_Days as InventotyAgeingdays ,
  Quantity_30,
  Value_30,
  Quantity_60,
  Value_60,
  Quantity_90,
  Value_90,
  Quantity_120,
  Value_120,
  Quantity_150,
  Value_150,
  Quantity_180,
  Value_180,
  Quantity_365,
  Value_365,
  Quantity_bucket,
  Value_bucket  
}
