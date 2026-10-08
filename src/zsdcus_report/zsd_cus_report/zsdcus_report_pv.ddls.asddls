@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Custom Report Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZSDCUS_REPORT_PV 
provider contract transactional_query
  as projection on ZSDCUS_REPORT_RV
{
@EndUserText.label: 'Invoice Number' 
@Search.defaultSearchElement: true                                                   
key BillingDocument,
key BillingDocumentItem,
  @Search.defaultSearchElement: true
key DeliveryDocument,
key DeliveryDocumentItem,
  @Search.defaultSearchElement: true
key SalesOrder,
key SalesOrderItem,
key bill_customer,
@EndUserText.label: 'Bill To Party'
SoldToParty,
  @Search.defaultSearchElement: true
ODNNumber,
  @Search.defaultSearchElement: true
Product,
  @Search.defaultSearchElement: true       
ProductDescription,
CreateMonth,
InvoiceDate,
CreationTime,
BillPartyName1,
BillPartyName2,
billcusStreetName,
billcusCityName,
billtoState,
        @ObjectModel.text.element: [ 'BillingDocumentTypeName' ]
BillingDocumentType,
BillingDocumentTypeName,
BaseUnit,
DeliveryQuantity,
BillingQuantity,
BasicPrice,
FreightPrice,
Commission,
Discount,
ProFreight,
Warranty,
NetValue,
TaxableValue,
IGSTamt,
CGSTamt,
SGSTamt,
TotalTaxValue,
Curr,
@Semantics.amount.currencyCode: 'Curr'
Roundoff,
TCS,
Freight_UOM,
BillingStatus,
TransactionCurrency,
GrossValue,
PortInvoiceValue,
ValueinUSD,
ZPROUSD,
EwayBillNo,
Ewaybilldate,
EinvoiceNo,
AckNoEinvoiceNo,
SalesOrganization,
DistributionChannel,
Division,
JournalEntryNo,
ExchangeRate,
HSN,
cussoref,
CompanyCode,
  @Search.defaultSearchElement: true                                                           
Plant,
OrderQuantity,
EndusCMR,
GSTNo,
TransporterName,
Vehiclenumber,
Drivername,
CustomerRef,
InvoiceTime,

//****ship to party
shipcusCityName,
shiptostate

}
