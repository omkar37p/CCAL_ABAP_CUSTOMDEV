@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Custom Report Part 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #TRANSACTIONAL
}
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZSD_REPORT_2PV 
provider contract transactional_query
as projection on ZSD_REPORT_2RV
{
@EndUserText.label: 'Invoice Number' 
@Search.defaultSearchElement: true                                                   
   key BillingDocument,
   key BillingDocumentItem,
   key DeliveryDocument,
   key DeliveryDocumentItem,
   key SalesOrder,
   key SalesOrderItem,
@Search.defaultSearchElement: true   
   ODNNumber,
   ReferenceSDDocument,
   ReferenceSDDocumentItem,
   CreationDate,
   CreationTime,
   SalesQuotation,
   SalesQuotationItem,
   SalesInquiry,
   SalesContract,
   shipCustomer,
   shipPartyName1,
   shipPartyName2,
   shipcusStreetName,
   shipcusCityName,
   shiptostate,
   TokenNumber,
   ModeofTransporter,
   BaseUnit,
   OrderQuantity,
   PendingQuantity,
   CustomerPaymentTerms,
   LRNo,
   DriverDetails,
   VolumePerCylinder,
   YY1_CylinderDetailSeal_DLH,
   FreightTerms,
   Remarks,
   Incoterms,
   IncLocation,
   JournalEntryNo,
   FiscalYear,
   TransporterName,
   Vehiclenumber,
   WheelerType,
   GrossWt,
   NetWt,
   TareWt,
   Concentration,
   Charwt,
   NoOfCylinder,
   Place,
@Search.defaultSearchElement: true   
   SalesOrganization,
@Search.defaultSearchElement: true   
   Division,
   HSN,
   cussoref,
@Search.defaultSearchElement: true   
   CompanyCode,
  @Search.defaultSearchElement: true                                                              
   Plant,
   InvoiceTime 
}
