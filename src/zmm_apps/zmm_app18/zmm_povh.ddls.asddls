@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity ZMM_POVH as select from I_PurchaseOrderAPI01
{
     @Search.defaultSearchElement: true
    key PurchaseOrder,
        PurchaseOrderType,
        PurchaseOrderDate,
      @Search.defaultSearchElement: true   
        Supplier
}
