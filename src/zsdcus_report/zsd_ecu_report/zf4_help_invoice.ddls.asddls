@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Invoice Number F4 Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZF4_HELP_INVOICE as select from I_BillingDocumentItem as BOI
                               left outer join I_DeliveryDocumentItem as DOI on DOI.DeliveryDocument = BOI.ReferenceSDDocument 
                                                and DOI.DeliveryDocumentItem = BOI.ReferenceSDDocumentItem
                               left outer join I_SalesOrderItem as SOI on SOI.SalesOrder = DOI.ReferenceSDDocument
                                                and SOI.SalesOrderItem = DOI.ReferenceSDDocumentItem

{
    @EndUserText.label: 'Invoice Number'
key BOI.BillingDocument,
    @EndUserText.label: 'Delivery Number'
key DOI.DeliveryDocument,
    @EndUserText.label: 'Sales Order'
key SOI.SalesOrder    
}
