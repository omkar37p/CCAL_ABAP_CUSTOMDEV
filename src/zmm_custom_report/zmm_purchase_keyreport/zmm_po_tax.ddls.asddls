@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Custom Tax View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_PO_TAX as select from ZMM_POKEY_INVTAX
{
    key PurchaseOrder,
    key PurchaseOrderItem,
    TaxCode,
    BaseUnit,
    DocumentCurrency,
    OrderQuantity,
    NetPriceAmount,
    NetAmount,
    IGSTAmount,
    CSGSTAmount as CGSTAmount,
    CSGSTAmount as SGSTAmount,
    DiscountAmt    
}
