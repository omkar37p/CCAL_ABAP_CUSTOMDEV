@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department Base Budget - Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP08_RPV
  provider contract transactional_query
  as projection on ZMM_APP08_RV
{
      @EndUserText.label: 'Plant'
      @ObjectModel.text.element: [ 'Plntname' ]
  key Plant,
      @EndUserText.label: 'Department'
      @ObjectModel.text.element: [ 'Deptname' ]
  key Deptid,
  key Bdgyear,
      @EndUserText.label: 'Valid From'
      Validon,
      @EndUserText.label: 'Valid To'
      Validto,
      Deptname,
      Plntname,
      @Semantics.amount.currencyCode : 'Curky'
      Allcbdg,
      Curky,
      Delemrk,
      Createdat,
      Createdby,
      /* Associations */
      _Item : redirected to composition child ZMM_APP08_IPV
}
