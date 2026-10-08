@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer F4 help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity ZQM_CUSTOMER_VH as select from I_Customer
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
