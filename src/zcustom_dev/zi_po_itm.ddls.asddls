@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Item Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PO_ITM 
as select from zpo_itm_dt
association to parent ZI_PO_HDR as _Header
    on $projection.PoId = _Header.PoId
{
    key po_id as PoId,
    key po_item as PoItem,
    material as Material,
    plant as Plant,
    storage_loc as StorageLoc,
    tax_code as TaxCode,
    @Semantics.quantity.unitOfMeasure : 'OrderUnit'
    order_qty as OrderQty,
    order_qty_unit as OrderUnit,
    @Semantics.amount.currencyCode : 'Currency'
    net_amount as NetAmount,
    currency_code as Currency,
    delivery_date as DeliveryDate,
    _Header
}
