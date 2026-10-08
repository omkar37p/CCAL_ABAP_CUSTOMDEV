@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Company Code Address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CCODE_ADDR1
  as select from    I_CompanyCode           as ccd
    inner join      I_Address_2             as Address     on Address.AddressID = ccd.AddressID
    left outer join I_AddressEmailAddress_2 as email       on email.AddressID = ccd.AddressID
    left outer join I_AddressPhoneNumber_2  as PhoneNumber on PhoneNumber.AddressID = ccd.AddressID
{
  key ccd.CompanyCode,
      ccd.CompanyCodeName,
      Address.AddressID,
      Address.AddresseeFullName,
      Address.OrganizationName1,
      Address.OrganizationName2,
      Address.OrganizationName3,
      Address.OrganizationName4,
      Address.CityName,
      Address.DistrictName,
      Address.VillageName,
      Address.PostalCode,
      Address.CompanyPostalCode,
      Address.Street,
      Address.StreetName,
      Address.Country,
      Address.Region,
      email.EmailAddress,
      PhoneNumber.PhoneAreaCodeSubscriberNumber,
      PhoneNumber.PhoneExtensionNumber
}
