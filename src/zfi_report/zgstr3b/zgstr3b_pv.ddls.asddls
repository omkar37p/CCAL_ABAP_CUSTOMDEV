@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR3B Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZGSTR3B_PV 
provider contract transactional_query
  as projection on ZGSTR3B_RVE
{
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key SourceLedger,
    key LedgerGLLineItem,
    key Ledger,
    DocumentReferenceID,
    DocumentDate,
    AccountingDocumentType,
    ProfitCenter,
    TransactionTypeDetermination,
    FiscalPeriod,
    GLAccount,
    BusinessPlace,
    buyergstin,
    Supplier,
    suppliergstin,
    suppliername,
    invoicestatus,
    supplytype,
    invoiceno,
    invoicedate,
    TaxCode,
    invoicetype,
//    notenumber,
    hsn_sac,
    uom,
    itemdescription,
    GST_Rate,
    itceligibility,
    eligibilitycategory,
    reversecharge,
    importtype,
    gstr2returnperiod,
    b3auto_fillperiod,
    PostingDate,
    CCURR,
    ReversalReferenceDocument,
    TaxItemGroup,
    TaxableValue,
    IGSTAmount,
    CGSTAmount,
    SGSTAmount,
          @Semantics.amount.currencyCode: 'Ccurr'         
    cessamount,
    InvoiceValue
}
