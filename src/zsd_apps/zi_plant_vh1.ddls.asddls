@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Process - Plant selection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PLANT_VH1
  as select from I_Plant
{
      @EndUserText.label: 'Shipping Point'
  key Plant     as Shpoint,
      @EndUserText.label: 'Shipping Point Name'
      PlantName as Shpname,
      ValuationArea,
      PlantCustomer,
      PlantSupplier,
      FactoryCalendar,
      DefaultPurchasingOrganization,
      SalesOrganization,
      AddressID,
      PlantCategory,
      DistributionChannel,
      Division,
      Language,
      IsMarkedForArchiving,
      BusinessPlace,
      /* Associations */
      //      _Address,
      _Customer,
      _MRPArea,
      _OrganizationAddress,
      _PlantCategoryText,
      _ResponsiblePurchaseOrg,
      _StandardOrganizationAddress,
      _Supplier,
      _ValuationArea
}
