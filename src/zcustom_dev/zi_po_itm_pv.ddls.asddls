@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Item Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZI_PO_ITM_PV 
as projection on ZI_PO_ITM
{
    key PoId,
    key PoItem,
    Material,
    Plant,
    StorageLoc,
    TaxCode,
    @Semantics.quantity.unitOfMeasure: 'OrderUnit'
    OrderQty,
    OrderUnit,
    @Semantics.amount.currencyCode: 'Currency'
    NetAmount,
    Currency,
    DeliveryDate,
    /* Associations */
    _Header : redirected to parent ZI_PO_HDR_PV
}
