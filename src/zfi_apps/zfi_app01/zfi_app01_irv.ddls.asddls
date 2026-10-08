@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Asix Bank Integration App Item Root View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_APP01_IRV as select from I_JournalEntryItem 
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    key Ledger,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    AmountInCompanyCodeCurrency,
    CompanyCodeCurrency

} where Ledger = '0L'
