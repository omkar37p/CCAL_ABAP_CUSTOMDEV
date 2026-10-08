@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Digital Signature Cockpit - PO Head'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZMM_APP17_POHD_RPV
  provider contract transactional_query
  as projection on ZMM_APP17_POHD_RV
{
          @Consumption.semanticObject: 'PurchaseOrder'
  key PurchaseOrder,
      PurchaseOrderItem,
//      @ObjectModel.text.element: [ 'PurchasingDocumentTypeName' ]      
      PurchaseOrderType,
      @ObjectModel.text.element: [ 'PersonFullName' ]
      CreatedByUser,
      CreationDate,
      PurchaseOrderDate,
      @ObjectModel.text.element: [ 'CCname' ]
      CompanyCode,
      DocumentCurrency,
      Customer,
      ExchangeRate,
      @ObjectModel.text.element: [ 'BPSupplierFullName' ]
      Vendorcode,
      PersonFullName,
      POApprovedBy,
      DestinationPlace,
      CusDeliveryDate,
      StanDeliveryDate,
      @ObjectModel.text.element: [ 'PlantName' ]
      Plant,
      IncotermsClassification,
      PriceBasic,
      FreightTerms,
      PaymentTermsCode,
      PaymentTermsDescription,
      BPSupplierFullName,
      StreetName,
      StreetPrefixName1,
      StreetPrefixName2,
      CityName,
      VenCountryName,
      PostalCode,
      GSTN,
      Region,
      BillcomName,
      Billadd1,
      Billstreet1,
      Billstreet2,
      Billcity,
      Billpostal,
      BillGSTN,
      BillRegion,
      ShipcomName,
      Shipadd1,
      Shipstreet1,
      Shipstreet2,
      Shipcity,
      Shippostal,
      ShipGSTN,
      ShipRegion,
      CCname,
      PlantName,
      Purchasestatus,
      Purchasekey,
      /* Associations */
      _Item : redirected to composition child ZMM_APP17_POIT_IPV
}
