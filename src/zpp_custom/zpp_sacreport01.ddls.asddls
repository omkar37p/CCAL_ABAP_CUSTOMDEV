@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PP SAC Report Custom view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
define view entity ZPP_SACREPORT01 as select from I_ManufacturingOrder as Head
inner join I_ManufacturingOrderItem as Item on Item.ManufacturingOrder = Head.ManufacturingOrder
left outer join I_ProductDescription as _prdes on _prdes.Product = Item.Product
                                              and _prdes.Language = $session.system_language
{
key Item.ManufacturingOrder as Orderno,
key Item.ManufacturingOrderItem,
    Item.Product as Material,
    _prdes.ProductDescription as MaterialDescription,
    Item.ProductionPlant as Plant,
    Item.BaseUnit as Unitofmeas,
    cast(Item.MfgOrderItemPlannedTotalQty as abap.dec( 15, 3 )) as TotalPlannedQuantity,
    cast(Item.MfgOrderItemGoodsReceiptQty as abap.dec( 15, 3 )) as GR_Quantity,
    Item.MfgOrderItemPlannedEndDate as PPDate    
}
