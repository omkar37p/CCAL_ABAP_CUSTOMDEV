@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Basic view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_JOURNAL as select from I_JournalEntry as JOH
inner join I_JournalEntryItem as JOI on JOI.CompanyCode = JOH.CompanyCode
                                                    and JOI.FiscalYear = JOH.FiscalYear
                                                    and JOI.AccountingDocument = JOH.AccountingDocument
                                                    and JOI.Ledger = '0L'
{
    key JOI.CompanyCode,
    key JOI.SourceLedger,
    key JOI.FiscalYear,
    key JOI.AccountingDocument,
    key JOI.LedgerGLLineItem,
    key JOI.Ledger,
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
        JOI.PostingKey,
        JOI.PostingDate,
        JOI.Supplier,
        cast( JOI.CreditAmountInBalanceTransCrcy as abap.dec( 13, 00 ) ) * -1 as ClearingAmt
}
where JOI.PostingKey = '31'
