@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZMM_APP18_RPV
  provider contract transactional_query
  as projection on ZMM_APP18_RV
{
  key PurchaseOrder,
      PurchaseOrderItem,
      PurchaseOrderType,
      PurchaseOrderDate,
      @ObjectModel.text.element: [ 'PersonFullName' ]
      CreatedByUser,
      CreationDate,
      @ObjectModel.text.element: [ 'CCname' ]
      CompanyCode,
      DocumentCurrency,
      Customer,
      ExchangeRate,
      PersonFullName,
      CusDeliveryDate,
      POApprovedBy,
      DestinationPlace,
      StanDeliveryDate,
      @ObjectModel.text.element: [ 'BPSupplierFullName' ]
      Vendorcode,
      @ObjectModel.text.element: [ 'PlantName' ]
      Plant,
      FreightTerms,
      PaymentTermsCode,
      PaymentTermsDescription,
      PriceBasic,
      IncotermsClassification,
      BPSupplierFullName,
      StreetName,
      StreetPrefixName1,
      StreetPrefixName2,
      PostalCode,
      GSTN,
      Region,
      VenCountryName,
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
      PurchaseOrderCategory,
      Purchasestatus,
      Purchasekey,
      /* Associations */
      _Item : redirected to composition child ZMM_APP18_IPV
}
