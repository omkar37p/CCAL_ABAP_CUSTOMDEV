@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Custom Report Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZFI_GSTR1_PV 
  provider contract transactional_query
  as projection on ZFI_GSTR1_RV
{

    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CompanyCodeStdVH',
                                                   element: 'CompanyCode' } }]
key CompanyCode, 
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_JournalEntryStdVH',
                                                   element: 'FiscalYear' } }]
key FiscalYear,  
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_JournalEntryStdVH',
                                                   element: 'AccountingDocument' } }]
key AccountingDocument, 
key SourceLedger, 
key LedgerGLLineItem, 
key Ledger, 
@EndUserText.label: 'Invoice Number'
key billdoc,  
key billitm, 
key hsnproduct,
key cuscustomer,
key Language,
key Country,
key Region,
key plaplant,
key supBusinessPlace,
TransactionCurrency,
TaxCode, 
GLAccount, 
PostingDate,
DocumentDate,
FiscalPeriod,
CompanyCodeCurrency,
Product,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_AccountingDocumentTypeText',
                                                   element: 'AccountingDocumentType' } }]
AccountingDocumentType,  
DocumentReferenceID,

BillToPartyRegion,
BillingDocumentType,  
InvoiceValue,  
AssignmentReference,
TaxableValue,  
igstConditionAmount,  
cgstconditionamount, 
sgstconditionamount, 
cessconditionamount,
freightAmount, 
TaxPerc,  

E_WayBillNo,  
E_WayBilldate,  
Einvoiceno,  
Einvoicedate,  
GSTR1RETURNPERIOD,  
BAUTOFILLPERIOD,
billdate, 
itmtxt,  
uom,  
@Semantics.quantity.unitOfMeasure: 'uom'
billqty,  
Divisionb,
ExportType,  
Notenumber,  
cuscode, 
custname,  
taxno2,  
UR_Type,  
hsncode,  
SupplierGSTIN,  
State, 
Supplytype1,  
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH',
                                                   element: 'Plant' } }]
    @EndUserText.label: 'Plant'
plant,  
PlantName,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
ExportAmount
}
