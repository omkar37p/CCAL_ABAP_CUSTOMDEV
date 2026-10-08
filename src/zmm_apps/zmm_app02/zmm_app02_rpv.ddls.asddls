@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Requisition - Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP02_RPV
  provider contract transactional_query
  as projection on ZMM_APP02_RV
{
  key Uuid,
      Purreqnum,
      Purreqdesc,
      @ObjectModel.text.element: [ 'Prtypdesc' ]
      @EndUserText.label: 'Document Type'
      Purreqtyp,
      Prtypdesc,
      Totitms,
      @Semantics.amount.currencyCode: 'Currency'
      Totnet,
      Currency,
      Status,
      Mark,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      /* Associations */
      _Item : redirected to composition child ZMM_APP02_IPV1
}
