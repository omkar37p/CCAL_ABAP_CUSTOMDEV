@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Help for Product'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity zpp_qm_productvh as select from I_ProductText
{
@Search.defaultSearchElement: true
    key Product,
    @UI.hidden: true
    key Language,
@Search.defaultSearchElement: true    
    ProductName 

}
