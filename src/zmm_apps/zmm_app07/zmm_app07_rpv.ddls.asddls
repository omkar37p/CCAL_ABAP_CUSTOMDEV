@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Header Root PEntity'
@Metadata.ignorePropagatedAnnotations: true 
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP07_RPV
  provider contract transactional_query
  as projection on ZMM_APP07_RV
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
      userid,
      Currency,
      Status,
      Mark,
      Delmark,
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
      _Item : redirected to composition child ZMM_APP07_IPV1
}
