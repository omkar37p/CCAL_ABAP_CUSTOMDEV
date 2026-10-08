@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Gate Entry Transporter Field VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TRANSPORTER_VH1
  as select from    I_Supplier                  as s
    left outer join I_SupplierToBusinessPartner as i on i.Supplier = s.Supplier
    left outer join I_BusinessPartner           as b on b.BusinessPartnerUUID = i.BusinessPartnerUUID
{
  key s.Supplier,
      s.SupplierName as SuppName,
      s.SupplierFullName,
      s.CityName,
      s.PostalCode,
      s.StreetName,
      s.Country

}
where
      s.SupplierAccountGroup =  'ZDOM'
  and b.BusinessPartnerType  =  'ZTRS'
  and s.DeletionIndicator    <> 'X'
