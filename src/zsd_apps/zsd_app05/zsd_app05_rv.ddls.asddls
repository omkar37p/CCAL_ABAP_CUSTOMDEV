@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Document - DSC Print Root entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP05_RV
  as select from I_BillingDocument
{
  key BillingDocument,
      BillingDocumentType,
      BillingDocumentDate,
      Division,
      SoldToParty,
      AccountingDocument
}
