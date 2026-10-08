@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Address View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_customer_view as select from I_Supplier as sup
left outer join I_RegionText as reg on reg.Region = sup.Region and reg.Language = 'E' and reg.Country = sup.Country
left outer join I_Address_2 as ADD on ADD.AddressID = sup.AddressID
{
   key sup.Supplier,
   key ADD.AddressID,
   sup.SupplierAccountGroup,
   sup.SupplierName,
   reg.RegionName,
   sup.BusinessPartnerName1,
   sup.BusinessPartnerName2,
   sup.BusinessPartnerName3,
   sup.BusinessPartnerName4,
   sup.BPAddrCityName,
   sup.BPAddrStreetName,
   sup.AddressSearchTerm1,
   sup.AddressSearchTerm2,
//   sup.DistrictName,
   sup.TaxNumber3,
   sup.CityName,
   sup.PostalCode,
   sup.StreetName,
   ADD.StreetPrefixName1,
   ADD.StreetPrefixName2,
   ADD.StreetSuffixName1,
   ADD.StreetSuffixName2,
   ADD.DistrictName,
   concat(sup.StreetName,concat( ADD.StreetPrefixName1,ADD.StreetPrefixName2)) as ADDRESS1,
   concat(sup.CityName,concat('PIN - ',sup.PostalCode)) as cipin,
   sup.PhoneNumber2 as phone
   
   
   
   

}
