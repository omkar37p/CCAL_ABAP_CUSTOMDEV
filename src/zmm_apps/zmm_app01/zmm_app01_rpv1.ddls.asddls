@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department User - Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP01_RPV1
  provider contract transactional_query
  as projection on ZMM_APP01_RV1
{
      @ObjectModel.text.element: [ 'Prodgrpname' ]
      @EndUserText.label: 'Department( Mat. Grp. )'
  key Prodgrp,
      @ObjectModel.text.element: [ 'Exgrpname' ]
      @EndUserText.label: 'Sub-Head'
  key Exprdgrp,
      Prodgrpname,
      Exgrpname
}
