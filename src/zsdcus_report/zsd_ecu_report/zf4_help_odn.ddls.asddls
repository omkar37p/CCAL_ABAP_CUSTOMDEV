@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD ODN Number F4 Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZF4_HELP_ODN as select from I_BillingDocumentItem as BOI
inner join I_BillingDocument as BOH on BOH.BillingDocument = BOI.BillingDocument
{
    
    @EndUserText.label: 'Invoice Number'
    @UI.lineItem: [{ position: 20 }]
    key BOI.BillingDocument,
    @UI.hidden: true
    key BOI.BillingDocumentItem,
    @EndUserText.label: 'ODN Reference Number'
    @UI.lineItem: [{ position: 10 }]
    BOH.DocumentReferenceID    
}
