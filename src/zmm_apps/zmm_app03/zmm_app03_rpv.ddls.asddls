@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Header - Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP03_RPV
  provider contract transactional_query
  as projection on ZMM_APP03_RV
{
  key Uuid,
      Ebeln,
      @EndUserText.label: 'PR Number'
      Banfn,
      Bukrs,
      @EndUserText.label: 'Document Type'
      @ObjectModel.text.element: [ 'Doctypdesc' ]
      Bsart,
      Doctypdesc,
      @EndUserText.label: 'Supplier'
      @ObjectModel.text.element: [ 'Suppname' ]
      Lifnr,
      Suppname,
      Ekorg,
      Ekgrp,
      Waers,
      Bedat,
      Mark,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
      _Item : redirected to composition child ZMM_APP03_IPV1
}
