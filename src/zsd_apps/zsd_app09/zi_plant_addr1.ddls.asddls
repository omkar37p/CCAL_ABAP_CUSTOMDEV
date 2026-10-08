@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant Address  - Structure Invoice Form'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PLANT_ADDR1
  as select from    I_Plant                 as plnt
    inner join      I_Address_2             as Addr        on Addr.AddressID = plnt.AddressID
    left outer join I_AddressEmailAddress_2 as email       on email.AddressID = plnt.AddressID
    left outer join I_AddressPhoneNumber_2  as PhoneNumber on PhoneNumber.AddressID = plnt.AddressID
{
  key plnt.Plant,
      plnt.PlantName,
      plnt.SalesOrganization,
      plnt.AddressID,
      plnt.PlantCategory,
      plnt.DistributionChannel,
      plnt.Division,
      plnt.Language,
      plnt.IsMarkedForArchiving,
      plnt.BusinessPlace,
      Addr.StreetName,
      Addr.Region,
      Addr.PostalCode,
      Addr.CityName,
      Addr.OrganizationName1,
      Addr.OrganizationName2,
      Addr.OrganizationName3,
      Addr.OrganizationName4

}
