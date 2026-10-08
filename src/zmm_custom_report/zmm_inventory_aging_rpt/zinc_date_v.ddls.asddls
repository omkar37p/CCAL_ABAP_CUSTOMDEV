@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM INVENTORY AGING REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZINC_DATE_V as select from 
I_MaterialDocumentItem_2 as gg
  //
{
  key gg.Material,
      gg.Batch,
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
//    where gg.ManufactureDate <> '00000000'
  //and gg.PostingDate <> '00000000'
group by
  gg.Material,
  gg.Batch,
  gg.Plant,
  gg.StorageLocation,
  gg.CompanyCode,
  gg.ManufactureDate,
  gg.SalesOrder,
  gg.SalesOrderItem,
  gg.Customer,
  gg.Supplier;

    
