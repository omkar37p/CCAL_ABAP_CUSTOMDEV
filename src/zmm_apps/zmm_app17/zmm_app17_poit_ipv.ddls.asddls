@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Digital Signature Cockpit - PO Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZMM_APP17_POIT_IPV 
as projection on ZMM_APP17_POIT_IV
{
    key PurchaseOrder,
    key PurchaseOrderItem,
    PurchaseOrderCategory,
    PurchaseOrderItemText,
    DocumentCurrency,
    MaterialGroup,
    Material,
    MaterialType,
    BaseUnit,
    CompanyCode,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    NetAmount,
    OrderPriceUnit,
    @Semantics.quantity.unitOfMeasure: 'OrderPriceUnit'
    OrderQuantity,
    Plant,
    TaxCode,
    HSN,
    StandardDate,
    Isdeleate,
    
///Purchase Order GST Tax Information
    IGSTContype,
    IGSTConrate,
    IGSTAmount,
    CGSTContype,
    CGSTConrate,
    CSGSTAmount,
    
    /* Associations */
    _Header : redirected to parent ZMM_APP17_POHD_RPV
}
