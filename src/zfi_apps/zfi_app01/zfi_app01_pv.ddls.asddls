@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Asix Bank Integration App Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_APP01_PV provider contract transactional_query as projection on ZFI_APP01_RV
{
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    AccountingDocumentType,
    DocumentDate,
    PostingDate,
    FiscalPeriod,
    DocumentReferenceID,
    DocumentReferenceID1,
    OriginalReferenceDocument,
    /* Associations */
    _item
}
