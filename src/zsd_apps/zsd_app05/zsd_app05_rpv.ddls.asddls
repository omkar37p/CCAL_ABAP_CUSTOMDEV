@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Doc - DSC Print Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP05_RPV
  provider contract transactional_query
  as projection on ZSD_APP05_RV
{
  key BillingDocument,
      BillingDocumentType,
      BillingDocumentDate,
      Division,
      SoldToParty,
      AccountingDocument
}
