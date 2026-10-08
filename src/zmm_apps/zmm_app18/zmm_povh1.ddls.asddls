@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@ObjectModel : { dataCategory: #VALUE_HELP }
define view entity ZMM_POVH1
  as select from I_PurchaseOrderAPI01
{
      @Search.defaultSearchElement: true
  key PurchaseOrder,
      @Search.defaultSearchElement: true
      PurchaseOrderDate,
      CompanyCode,
      @Search.defaultSearchElement: true
      PurchaseOrderType
}
