@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Custom PR Type'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X, 
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PurchaseRequisitionType
  as select from I_PurchasingDocumentType

  association [0..*] to I_PurchasingDocumentTypeText as _Text on  $projection.PurchaseRequisitionType = _Text.PurchasingDocumentType
                                                              and _Text.PurchasingDocumentCategory    = 'B'
                                                              and _Text.Language                      = 'E'
{
  key PurchasingDocumentCategory as PurchasingDocumentCategory,
      @ObjectModel.text.association: '_Text'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
  key PurchasingDocumentType     as PurchaseRequisitionType,
      PurchasingDocumentSubtype,
      PurgHasFlxblWorkflowApproval,
      @EndUserText.label: 'Is Overall Release Enabled'
      IsPurReqnOvrlRel,
      _Text
}
where
      PurchasingDocumentCategory = 'B'
  and PurchasingDocumentType     = 'ZOXD'
  or  PurchasingDocumentType     = 'ZOXI'
