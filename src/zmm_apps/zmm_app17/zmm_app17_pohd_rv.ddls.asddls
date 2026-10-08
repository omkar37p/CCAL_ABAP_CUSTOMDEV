@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Digital Signature Cockpit - PO Form'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define root view entity ZMM_APP17_POHD_RV
  as select from ZMM_APP18_HEADER as POH
  composition [0..*] of ZMM_APP17_POIT_IV as _Item
{
  key POH.PurchaseOrder,
      POH.PurchaseOrderItem,
      POH.PurchaseOrderType,
      POH.CreatedByUser,
      POH.CreationDate,
      POH.PurchaseOrderDate,
      POH.CompanyCode,
      POH.DocumentCurrency,
      POH.Customer,
      POH.ExchangeRate,
      POH.Vendorcode,
      POH.PersonFullName,
      POH.POApprovedBy,
      POH.DestinationPlace,
      POH.CusDeliveryDate,
      POH.StanDeliveryDate,
      POH.Plant,
      POH.IncotermsClassification,
      POH.PriceBasic,
      POH.FreightTerms,
      POH.PaymentTermsCode,
      POH.PaymentTermsDescription,
      POH.BPSupplierFullName,
      POH.StreetName,
      POH.StreetPrefixName1,
      POH.StreetPrefixName2,
      POH.PostalCode,
      POH.CityName,
      POH.VenCountryName,
      POH.GSTN,
      POH.Region,
      POH.BillcomName,
      POH.Billadd1,
      POH.Billstreet1,
      POH.Billstreet2,
      POH.Billcity,
      POH.Billpostal,
      POH.BillGSTN,
      POH.BillRegion,
      POH.ShipcomName,
      POH.Shipadd1,
      POH.Shipstreet1,
      POH.Shipstreet2,
      POH.Shipcity,
      POH.Shippostal,
      POH.ShipGSTN,
      POH.ShipRegion, 
      POH.CCname,
      POH.PlantName,
      POH.Purchasestatus,
      POH.Purchasekey,
//      POH.PurchasingDocumentTypeName,
           
      _Item
}
