@AbapCatalog.sqlViewName: 'ZMMINVENTORYVIEW'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM INVENTORY AGING REPORT'
@Metadata.ignorePropagatedAnnotations: true
define view ZMM_INVENTORY_AG_VIEW as select from I_MaterialDocumentItem_2 as gg
{
    key gg.Material,
//    key gg.MaterialDocument,
      gg.Batch,
      gg.CompanyCodeCurrency,
      gg.Plant,
      gg.StorageLocation,
      max(gg.ManufactureDate) as Pos1,
      max(gg.PostingDate)     as Pos,
      gg.CompanyCode,
      gg.SalesOrder           as sales,
      gg.SalesOrderItem       as Sitem,
      gg.Customer,
      gg.Supplier

}
where
      gg.StorageLocation <> ' '
  and gg.Supplier        <> ''
group by
  gg.Material,
//  gg.MaterialDocument,
  gg.Batch,
  gg.Plant,
  gg.StorageLocation,
  gg.CompanyCode,
  gg.ManufactureDate,
  gg.SalesOrder,
  gg.SalesOrderItem,
  gg.Customer,
  gg.Supplier,
  gg.CompanyCodeCurrency;  
