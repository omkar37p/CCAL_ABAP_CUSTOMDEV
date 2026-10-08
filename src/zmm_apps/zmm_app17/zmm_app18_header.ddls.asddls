@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC Header view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define root view entity ZMM_APP18_HEADER
  as select from    I_PurchaseOrderAPI01          as POH
    left outer join      I_PurchaseOrderItemAPI01      as POI         on  POI.PurchaseOrder     = POH.PurchaseOrder
                                                                 and POI.PurchaseOrderItem = '00010'
    left outer join I_BusinessUserBasic           as UserName    on UserName.UserID = POH.CreatedByUser
    left outer join ZMM_APP17_SUPADD              as Vendor      on Vendor.Supplier = POH.Supplier
    left outer join I_CountryText                 as VenCtext    on  VenCtext.Country  = Vendor.Country
                                                                 and VenCtext.Language = $session.system_language
    left outer join I_Address_2                   as VenAdd      on VenAdd.AddressID = Vendor.AddressID
    left outer join I_PaymentTermsText            as pyt         on  pyt.PaymentTerms = POH.PaymentTerms
                                                                 and pyt.Language     = $session.system_language
    left outer join I_CompanyCode                 as Companyname on Companyname.CompanyCode = POH.CompanyCode
    left outer join I_Plant                       as PlantName   on PlantName.Plant = POI.Plant
    left outer join I_IncotermsClassificationText as IncoText    on  IncoText.IncotermsClassification = POH.IncotermsClassification
                                                                 and IncoText.Language                = $session.system_language
  //    left outer join I_PurchasingDocumentTypeText as Puttext on Puttext.PurchasingDocumentType = POH.PurchaseOrderType
  //                                                        and POI.PurchaseOrderItemCategory = Puttext.PurchasingDocumentCategory
  //                                                        and Puttext.Language = $session.system_language

    left outer join ZMM_APP17_PLANTADD            as Ship        on Ship.Plant = POI.Plant
    left outer join ZMM_APP17_POWFS               as Postatus    on Postatus.SAPBusinessObjectNodeKey1 = POH.PurchaseOrder
{
  key POH.PurchaseOrder,
      POI.PurchaseOrderItem,
      POI.PurgDocPriceDate,
      POH.PurchaseOrderType,
      POH.PurchaseOrderDate,
      POH.CreatedByUser,
      POH.CreationDate,
      POH.CompanyCode,
      POH.DocumentCurrency,
      POH.Customer,
      POH.ExchangeRate,
      UserName.PersonFullName,
      POH.YY1_ZDELIVERY_DATE_PDH           as CusDeliveryDate,
      POH.YY1_APPROVEDBY_PO_PDH            as POApprovedBy,
      POH.YY1_DestinationPlace_PDH         as DestinationPlace,
      POI.PurgDocPriceDate                 as StanDeliveryDate,
      POH.Supplier                         as Vendorcode,
      POI.Plant,
      POH.IncotermsTransferLocation        as FreightTerms,
      POH.PaymentTerms                     as PaymentTermsCode,
      pyt.PaymentTermsDescription          as PaymentTermsDescription,
      case
            when IncoText.IncotermsClassification = 'CIF' then 'Costs, Insurance and Freight'
            else IncoText.IncotermsClassificationName end as PriceBasic,
      POH.IncotermsClassification,
      ///Supplier Address
      Vendor.BPSupplierFullName,
      Vendor.StreetName,
      VenAdd.StreetPrefixName1,
      Vendor.StreetPrefixName2,
      Vendor.PostalCode,
      Vendor.CityName,
      Vendor.TaxNumber3                    as GSTN,
      substring(Vendor.TaxNumber3,1,2)     as Region,
      VenCtext.CountryName                 as VenCountryName,
      ///Bill to Address
      Ship.OrganizationName1               as BillcomName,
      Ship.OrganizationName2               as Billadd1,
      Ship.StreetPrefixName1               as Billstreet1,
      Ship.StreetName                      as Billstreet2,
      Ship.CityName                        as Billcity,
      Ship.PostalCode                      as Billpostal,
      Ship.gstin                           as BillGSTN,
      substring(Ship.gstin,1,2)            as BillRegion,
      ///Ship to Address
      Ship.OrganizationName1               as ShipcomName,
      Ship.OrganizationName2               as Shipadd1,
      Ship.StreetPrefixName1               as Shipstreet1,
      Ship.StreetName                      as Shipstreet2,
      Ship.CityName                        as Shipcity,
      Ship.PostalCode                      as Shippostal,
      Ship.gstin                           as ShipGSTN,
      substring(Ship.gstin,1,2)            as ShipRegion,
      Companyname.CompanyCodeName          as CCname,
      PlantName.PlantName                  as PlantName,
      POI.PurchaseOrderCategory,
      //      case
      //            when Postatus.WorkflowExternalStatus = ' ' then 'Open PO'
      //            else Postatus.WorkflowExternalStatus  end as Purchasestatus
      Postatus.WorkflowExternalStatus      as Purchasestatus,
      Postatus.SAPObjectNodeRepresentation as Purchasekey
      //      Puttext.PurchasingDocumentTypeName

}
