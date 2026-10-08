@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Report - Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S, 
    dataClass: #MIXED
}
define root view entity ZMM_APP11_RPV
  provider contract transactional_query
  as projection on ZMM_APP11_RV
{
  key Bdgcode,
      @EndUserText.label: 'Plant'
      @ObjectModel.text.element: [ 'Plntname' ]
      Plant,
      Deptid,
      Validon,
      Validto,
      Plntname,
      @EndUserText.label: 'Department'
      Deptname,
      Curky,
      @Semantics.amount.currencyCode: 'Curky'
      Basebdg,
      @Semantics.amount.currencyCode: 'Curky'
      Talcbdg,
      Bdghtxt,
      Bdgtype,
      @Semantics.amount.currencyCode: 'Curky'
      totpoamt,
      @Semantics.amount.currencyCode: 'Curky'
      bdgbal,
      _poline : redirected to composition child ZMM_APP11_IPV1
}
