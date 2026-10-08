@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PP SAC Report Custom view 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
define view entity ZPP_SACREPORT02 as select from I_ManufacturingOrder as Head
inner join I_ManufacturingOrderItem as Item on Item.ManufacturingOrder = Head.ManufacturingOrder
left outer join I_ProductDescription as _prdes on _prdes.Product = Item.Product
                                              and _prdes.Language = $session.system_language
left outer join I_MaterialDocumentItem_2 as Grn on Grn.Material = Item.Product
                                                and Grn.OrderID = Item.ManufacturingOrder
                                                and Grn.OrderItem = Item.ManufacturingOrderItem
{
key Item.ManufacturingOrder as Orderno,
key Item.ManufacturingOrderItem,
    Item.Product as Material,
    _prdes.ProductDescription as MaterialDescription,
    Item.ProductionPlant as Plant,
    Grn.EntryUnit as Unitofmeas,
    cast(Grn.QuantityInBaseUnit as abap.dec( 15, 3 )) as GR_Quantity,
    Grn.PostingDate as PostDate,
    Grn.GoodsMovementType as MovementType    
}
where Grn.GoodsMovementType = '101' or Grn.GoodsMovementType = '102'
