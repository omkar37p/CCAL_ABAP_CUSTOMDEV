@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Asix Bank Integration App Root View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_APP01_RV as select from I_JournalEntry
association[0..*] to ZFI_APP01_IRV as _item on _item.AccountingDocument = $projection.AccountingDocument and _item.CompanyCode = $projection.CompanyCode
and _item.FiscalYear = $projection.FiscalYear 
{
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    AccountingDocumentType,
    DocumentDate,
    PostingDate,
    FiscalPeriod,
    AccountingDocumentHeaderText as DocumentReferenceID,
    DocumentReferenceID as DocumentReferenceID1,
    OriginalReferenceDocument,
    _item
    
} where AccountingDocumentType = 'ZP' or AccountingDocumentType = 'KZ'
