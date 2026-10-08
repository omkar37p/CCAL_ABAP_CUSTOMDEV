@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Customer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity zpp_qm_customer_vh as select from I_Customer
{
@Search.defaultSearchElement: true
  key Customer,
@Search.defaultSearchElement: true  
  BPCustomerFullName,
  StreetName,
  CityName,
  Country,
  Region,
  PostalCode

}
