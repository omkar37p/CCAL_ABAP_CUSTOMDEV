@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Partial Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_JVPARTIAL_AMT as select from ZMM_JOURNAL as JOI
left outer join I_JournalEntryItem as PAM on  PAM.InvoiceReference = JOI.AccountingDocument
                                          and PAM.CompanyCode = JOI.CompanyCode
                                          and  PAM.InvoiceReferenceFiscalYear = JOI.FiscalYear 
                                          and  PAM.InvoiceItemReference = JOI.AccountingDocumentItem
                                          and PAM.Ledger = '0L'
{
    key JOI.CompanyCode,
    key JOI.SourceLedger,
    key JOI.FiscalYear,
    key JOI.AccountingDocument,
    key JOI.LedgerGLLineItem,
    key JOI.Ledger,
    key PAM.AccountingDocument as Accno,
    JOI.AccountingDocumentItem,
    JOI.PurchasingDocument,
    JOI.PurchasingDocumentItem,
    JOI.ReferenceDocument,
    JOI.ReferenceDocumentItem,
    JOI.ClearingAccountingDocument,
    JOI.ClearingDate,
    JOI.ClearingDocFiscalYear,
    JOI.ClearingJournalEntry,
    JOI.ClearingJournalEntryFiscalYear,
    JOI.ClearingAmt,
    JOI.PostingKey,
    JOI.PostingDate,
    JOI.Supplier,
    
    PAM.AccountingDocumentItem as accitem,
    PAM.InvoiceReference,
    PAM.InvoiceItemReference,
    PAM.InvoiceReferenceFiscalYear,
    cast(PAM.DebitAmountInBalanceTransCrcy as abap.dec( 23, 2 )) as PaymentAmount
}
